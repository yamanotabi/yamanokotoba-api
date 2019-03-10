namespace :query do
  task :create => :environment do
    p Word.create(text: 'そこに山があるから。', user_name: 'ジョージ・マロリー', background_image_url: 'https://yamabluesky.files.wordpress.com/2019/01/slide01-2.jpg', user_image_url: '')
    p Word.create(text: '山はこれ以上大きくならないが、私たちはいくらでも成長できる。', user_name: 'エドモンド・ヒラリー', background_image_url: 'https://yamabluesky.files.wordpress.com/2019/01/pexels-photo-26419.jpg', user_image_url: '')
    p Word.create(text: '登頂がすべてではない。登山をするということすべてを楽しみたい。', user_name: '竹内洋岳', background_image_url: 'https://yamabluesky.files.wordpress.com/2019/01/mountkinabalu-1024x682.jpg', user_image_url: '')
    p Word.create(text: '目の前の山に登りたまえ。山は君の全ての疑問に答えてくれるだろう。', user_name: 'ラインポルト・メスナー', background_image_url: 'https://yamabluesky.files.wordpress.com/2019/01/1024px-mount_aino_fom_mount_kita_2001-7-2.jpg', user_image_url: '')
    p Word.create(text: '単独行者よ、強くなれ！', user_name: '加藤文太郎', background_image_url: 'https://yamabluesky.files.wordpress.com/2019/01/75d1d9e2.jpg', user_image_url: '')
  end
  task :show => :environment do
    Word.where(id: '5c8472673211d781c692b6df').each do |word|
      p word
    end
  end
  task :deleteAll => :environment do
    @words = Word.all
    @words.each do |word|
      Word.where(text: word.text).delete()
    end
  end

  task :delete => :environment do
    Word.where(id: '5c84858a3211d781c692b6e1').delete()
  end

  task :all => :environment do
    @words = Word.all
  end
end
