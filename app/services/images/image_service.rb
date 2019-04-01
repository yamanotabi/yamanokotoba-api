module Images
    module ImageService
        require 'mini_magick'

        GRAVITY = 'center'.freeze
        TEXT_POSITION = '0,0'.freeze
        FONT = 'app/assets/fonts/komorebi-gothic.ttf'.freeze
        FONT_SIZE = 45
        INDENTION_COUNT = 15

        class << self
            def upload(data, text)
                s3 = AWS::S3.new(
                    :access_key_id     => ENV["AWS_ACCESS_KEY_ID"],
                    :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"],
                    :region => 'ap-northeast-1')
                bucket = s3.buckets[ENV["S3_BUCKET"]]
                @data = data
                @image = MiniMagick::Image.read(data)
                @image.resize "900x600"
                
                file_name = @data.original_filename
                file_full_path="images/"+file_name

                build(text)

                post = ActionDispatch::Http::UploadedFile.new(
                    filename:file_name,
                    type: 'image/png',
                    tempfile: @image.tempfile
                )

                object = bucket.objects[file_full_path]
                object.write(post.open, :acl => :public_read)

                # "http://s3-ap-northeast-1.amazonaws.com/images/#{file_name}"
                return "http://s3-ap-northeast-1.amazonaws.com/images/#{file_name}"
            end

            # 合成後のFileClassを生成
            def build(text)
                text = prepare_text(text)
                configuration(text)
            end

            private    
            # 設定関連の値を代入
            def configuration(text)
                @image.combine_options do |config|
                config.font FONT
                config.gravity GRAVITY
                config.pointsize FONT_SIZE
                config.fill("#FFFFFF") 
                config.draw "text #{TEXT_POSITION} '#{text}'"
                end
            end

            # 背景にいい感じに収まるように文字を調整して返却
            def prepare_text(text)
                text.scan(/.{1,#{INDENTION_COUNT}}/)[0...(text.length / INDENTION_COUNT + 1)].join("\n")
            end
        end
    end
end
