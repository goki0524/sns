# if Rails.env.production?
#   CarrierWave.configure do |config|
#     config.fog_credentials = {
#       # Amazon S3用の設定
#       # TODO: AWS登録しproduction環境で画像のアップロードを行えるようにする.<railstutorial 13.4.4参照>
#       :provider              => 'AWS',
#       :region                => ENV['ap-northeast-1'],
#       :aws_access_key_id     => ENV['AKIAJYY2PTBLEB4LRKQA'],
#       :aws_secret_access_key => ENV['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']
#     }
#     config.fog_directory     =  ENV['railsgoki']
#   end
# end