// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { $ } from "jquery"

let points = 0
let total = 0
let kanas_list = []
let current = null
let mistakes = []
let intervalVariable = undefined
let intervalTime = 10
let timeleft = 0
let types = undefined
let name = undefined

$(document).on('click', '.start-button, .restart-button', function () {
    if (name === undefined) {
        name = $('#input_name').val().trim()
        if ((name.length === 0) || (name.length > 255)) {
            name = 'Аноним'
        }
    }
    types = $('input[name="kana_type"]:checked').map((_, el) => el.value).get()
    if (types.length === 0) {
        show_screen('start')
        $('.kc-error').prop('hidden', false)
        return
    }
    $('.kc-error').prop('hidden', true)

    let button = $(this).prop('disabled', true)
    loadKanas(types).then(() => {
        reset_game()
        show_screen('game')
        start_timer()
        game_logic()
    }).finally(() => button.prop('disabled', false))
})

$(document).on('change', 'input[name="kana_type"]', function () {
    $('.kc-error').prop('hidden', true)
})

$(document).on('submit', '.kc-answer', function (e) {
    e.preventDefault()
    if (!current) return

    let value = $('#input_kana').val().trim().toLowerCase()
    if (value === '') return
    console.log(current)
    let correct = value === current.translation.toLowerCase()
    if (correct) {
        points++
        increment_kana(current.type, current.translation, true)
    } else {
        mistakes.push({ kana: current.kana, translation: current.translation, answer: value })
        increment_kana(current.type, current.translation, false)
    }
    show_feedback(correct)

    if (kanas_list.length > 0) {
        game_logic()
    } else {
        stop_timer()
        game_end()
    }
})

$(document).on('turbo:before-visit', stop_timer)


function increment_kana(type, kana, correct) {
    let kana_result = undefined
    if (correct === true){
        kana_result = {
            type: type,
            kana: kana,
            increment: 'yes',
            correct: 'yes'
        }
    } else {
        kana_result = {
            type: type,
            kana: kana,
            increment: 'yes'
        }
    }
    fetch('api/kana', {
        method: 'POST',
        headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(kana_result)
    })
        .then(resp => {
            if (!resp.ok) {
                throw new Error('HTTP Error! Code: ' + resp.status)
            }
            return resp.json()
        })
}

function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        let j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array
}

async function loadKanas(types) {
    const game_types = encodeURIComponent(types.join(','))
    const response = await fetch('/api/kana?type=' + game_types)
    const data = await response.json()
    kanas_list = shuffle(data.map(val => ({ kana: val.kana, translation: val.translation.toString(), type: val.kana_type })))
    total = kanas_list.length
}

function reset_game() {
    points = 0
    mistakes = []
    timeleft = 0
    $('.timer').text(format_time(0))
    $('.kc-feedback').text('').removeClass('is-correct is-wrong')
}

function show_screen(name) {
    $('.kc-screen').prop('hidden', true)
    $('.kc-screen--' + name).prop('hidden', false)
}

function game_logic() {
    current = kanas_list.shift()
    $('.current_kana').text(current.kana)
    $('.kc-points').text(points)
    $('.kc-left').text(kanas_list.length + 1)
    $('.kc-progress__bar').css('width', ((total - kanas_list.length - 1) / total * 100) + '%')
    $('#input_kana').val('').trigger('focus')
}

function show_feedback(correct) {
    let card = $('.kc-card').removeClass('is-correct is-wrong')
    card[0].offsetWidth
    card.addClass(correct ? 'is-correct' : 'is-wrong')

    let last = mistakes[mistakes.length - 1]
    $('.kc-feedback')
        .removeClass('is-correct is-wrong')
        .addClass(correct ? 'is-correct' : 'is-wrong')
        .text(correct ? 'Верно!' : 'Неверно: ' + last.kana + ' — ' + last.translation)
}

function game_end() {
    current = null
    $('.kc-result-points').text(points + '/' + total)
    $('.kc-result-accuracy').text(Math.round(points / total * 100) + '%')
    $('.kc-result-time').text(format_time(timeleft) + 's')
    let score = calculate_score(points, total, timeleft)
    $('.kc-result-score').text(score)
    const gameResults = {
        game: {
            game_name: 'classic,' + types.join(','),
            points: score,
            time: format_time(timeleft),
            kana_count: total,
            kana_right: points,
            name: name
        }
    }
    fetch('api/game', {
        method: 'POST',
        headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(gameResults)
    })
        .then(resp => {
            if (!resp.ok) {
                throw new Error('HTTP Error! Code: ' + resp.status)
            }
            return resp.json()
        })
        .then(data => {
            console.log(data)
        })
        .then(error => {
            console.log(error)
        })
    let list = $('.kc-mistakes__list').empty()
    mistakes.forEach(m => {
        list.append(
            $('<li>').append(
                $('<span class="kc-mistakes__kana">').text(m.kana),
                $('<s>').text(m.answer),
                $('<span>').text(m.translation)
            )
        )
    })
    $('.kc-mistakes').prop('hidden', mistakes.length === 0)

    show_screen('result')
}

function calculate_score(right, total, ms) {
    let seconds = Math.max(ms / 1000, Math.E)
    return Math.round(right / total / Math.log(seconds) * 1000)
}

function start_timer() {
    stop_timer()
    intervalVariable = setInterval(update_time, intervalTime)
}

function stop_timer() {
    clearInterval(intervalVariable)
    intervalVariable = undefined
}

function update_time() {
    timeleft = timeleft + intervalTime
    $('.timer').text(format_time(timeleft))
}

function format_time(ms) {
    return Math.floor(ms / 1000) + '.' + String(Math.floor(ms % 1000 / 10)).padStart(2, '0')
}
