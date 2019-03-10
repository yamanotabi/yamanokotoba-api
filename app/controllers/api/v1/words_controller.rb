module Api
    module V1
        class Api::V1::WordsController < ApplicationController
            before_action :set_word, only:[:show, :destroy]

            # GET /api/v1/word
            def index
                @words = Word.all
                render json: @words
            end

            # POST /api/v1/word
            def create
                @word = Word.new(word_params)
                # TODO: 
                # if image_url == nil => add image_url
                if @word.save
                  render json: @word, status: :created
                else
                  render json: @word.errors, status: :unprocessable_entity
                end
            end

            # GET /api/v1/word/:id
            def show
                render json: @word
            end

            # DELETE /api/v1/word/:id
            def destroy
                @word.destroy
                render status: 200, json: { status: 200, message: "Delete success #{@word.text}" }
            end

            def set_word
                @word = Word.find(params[:id])
            end
        
            private
            def word_params
                params.require(:word).permit(:text, :user_name, :background_image_url, :user_image_url)
            end
        end
    end
end