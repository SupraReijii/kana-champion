class Api::ApiKanaController < ApiController
  def index
    type = if params["type"].present?
      params["type"].split(",")
    else
      "hiragana"
    end
    kanas = Kana.where(kana_type: type)
    render json: kanas.to_json, status: 200
  end
end