class Api::ApiKanaController < ApiController
  def index
    type =
      if params["type"].present?
        params["type"].split(",")
      else
        ["hiragana"]
      end
    kanas =
      if KanaChampion::REDIS.get("API:KANA_CONTROLLER:INDEX:#{type.join(',')}").nil?
        puts "MISS"
        result = Kana.where(kana_type: type)
        KanaChampion::REDIS.setex("API:KANA_CONTROLLER:INDEX:#{type.join(',')}", 3600, result.to_json)
        result
      else
        puts "HIT"
        JSON.parse(KanaChampion::REDIS.get("API:KANA_CONTROLLER:INDEX:#{type.join(',')}"))
      end
    render json: kanas.to_json, status: 200
  end


  def update
    if params["increment"].present?
      if KanaChampion::REDIS.get("API:KANA_CONTROLLER:UPDATE:#{params["type"]}:#{params["kana"]}").nil?
        KanaChampion::REDIS.set("API:KANA_CONTROLLER:UPDATE:#{params["type"]}:#{params["kana"]}", '0')
      end
      KanaChampion::REDIS.incr("API:KANA_CONTROLLER:UPDATE:#{params["type"]}:#{params["kana"]}")
      if params["correct"].present?
        if KanaChampion::REDIS.get("API:KANA_CONTROLLER:UPDATE:#{params["type"]}:#{params["kana"]}:CORRECT").nil?
          KanaChampion::REDIS.set("API:KANA_CONTROLLER:UPDATE:#{params["type"]}:#{params["kana"]}:CORRECT", '0')
        end
        KanaChampion::REDIS.incr("API:KANA_CONTROLLER:UPDATE:#{params["type"]}:#{params["kana"]}:CORRECT")
      end
      render json: { status: "ok" }, status: 200
    else
      render json: { status: "No param increment" }, status: 400
    end
  end
end