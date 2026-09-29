// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { $ } from "jquery"

let game_container = $('.game')
let points = 0
let game_kanas = {
    "a": "あ", "i": "い", "u": "う", "e": "え", "o": "お",
    "ka": "か", "na": "な", "ta": "た"
}
let kanas_list = shuffle(Object.keys(game_kanas))
let intervalVariable = undefined;
let intervalTime = 5;
let timeleft = 0;


$('.start-button').on('click', function (){
    $('.start-button').css('visibility', 'hidden')
    start_timer()
    game_logic()
})

$(document).on('keydown', '#input_kana', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        let point = $('.current_kana').attr('data-value')
        let value = $('#input_kana').val()
        if (point === value) {
            points++
        } else {
            console.log('false')
        }
        if (kanas_list.length > 0) {
            game_logic()
        } else {
            game_end(timeleft).then(r => stop_timer())
        }
    }
});

function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        let j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array
}

function game_logic(){
    let current_kana = kanas_list.shift()
    game_container.html('<p class="current_kana" data-value="'+ current_kana +'">' + game_kanas[current_kana] + '</p><input id="input_kana">')
    $('#input_kana').focus()
}

async function game_end(timeleft){
    game_container.html('<h1>GAME OVER</h1>' +
        '<h2>Your points: ' + points + '</h2>' +
        '<h2>Your time: ' + timeleft / 1000 + ' seconds</h2>')
}

function start_timer(){
    intervalVariable = setInterval(update_time, intervalTime)
}

function stop_timer() {
    clearInterval(intervalVariable)
    timeleft = 0
    $('.timer').html('<span></span>')
}

function update_time(){
    timeleft = timeleft + intervalTime;
    $('.timer').html('<span>' + Math.floor(timeleft / 1000) + '.' + Math.floor(timeleft % 1000 / 10) + '</span>')
}