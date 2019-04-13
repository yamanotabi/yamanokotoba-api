module Api
    module V1
        require 'securerandom'
        require 'json'

        WORD_PREFIX = 'w_'.freeze
        USER_PREFIX = 'u_'.freeze

        class Api::V1::WordsController < ApplicationController
            before_action :set_word, only:[:show, :destroy]
            # before_action :set_twitter_client, only:[:create]

            # GET /api/v1/word
            def index
                # scan from redis
                words = []
                REDIS.keys('w_*').reverse_each do |key|
                    words.push(JSON.parse(REDIS.get(key)))                    
                end
                render json: words

                # scan from mongodb
                # @words = Word.all
                # render json: @words
            end

            # POST /api/v1/word
            def create
                @word = Word.new

                text = params[:text]
                
                @word.id = WORD_PREFIX + params[:id]
                @word.text = text
                @word.user_name = params[:user_name]
                @word.user_image_url = params[:user_image_url]
                @word.user_id = USER_PREFIX + params[:user_id]
                # imageに文字を重ねて、S3にアップロードする
                @word.background_image_url = Images::ImageService.upload(params[:file], params[:text])
                @word.tweet_text = params[:tweet_text]

                begin
                    # 先にmongodbに登録する
                    if @word.save
                        # register to redis
                        REDIS.set(@word.id, @word.to_json)
                        REDIS.lpush(@word.user_id, @word.id)

                        render json: @word, status: :created and return
                    else
                        render json: @word.errors, status: :unprocessable_entity and return
                    end
                rescue => e
                    error = e
                    render json: error and return
                end
            end

            # GET /api/v1/word/:id
            def show
                @word = REDIS.get(params[:id])
                render json: @word
            end

            # Get /api/v1/users/:user_id/words
            def getByUser
                word_ids = REDIS.lrange(USER_PREFIX + params[:user_id], 0, -1)
                words = []
                word_ids.each do |key|
                    words.push(JSON.parse(REDIS.get(key)))
                end
                render json: words

                # get from mongodb
                # @words = Word.where(user_id: params[:user_id])
                # render json: @words
            end

            # DELETE /api/v1/word/:id
            def destroy
                @word.destroy
                render status: 200, json: { status: 200, message: "Delete success #{@word.text}" }
            end

            def set_word
                @word = Word.find(params[:id])
            end
        
            # def set_twitter_client
            #     @twitter = Twitter::REST::Client.new do |config|
            #       config.consumer_key        = ENV["TWITTER_API_KEY"]
            #       config.consumer_secret     = ENV["TWITTER_API_SECRET_KEY"]
            #       config.access_token        = params[:access_token]
            #       config.access_token_secret = params[:access_token_secret]
            #     end
            # end
        end
    end
end