class Home < ActiveRecord::Base
  


  def self.test_dropbox
    # Install this the SDK with "gem install dropbox-sdk"
    require 'dropbox_sdk'
# Get your app key and secret from the Dropbox developer website


    flow = DropboxOAuth2FlowNoRedirect.new('wb82ws1fikrhwyg', '1u3v87temqiceoc')
    authorize_url = flow.start()

# Have the user sign in and authorize this app
# puts '1. Go to: ' + authorize_url
# puts '2. Click "Allow" (you might have to log in first)'
# puts '3. Copy the authorization code'
# print 'Enter the authorization code here: '

# This will fail if the user gave us an invalid authorization code
    access_token, user_id = '8HFipp0Yd3UAAAAAAAAA8GC3R6wlN99qsXuK7RDoPtXeowWRGmCSwiwwBc3lH1mH'

    client = DropboxClient.new(access_token)
    puts "linked account:", client.account_info().inspect

# file = open('working-draft.txt')
# response = client.put_file('/magnum-opus.txt', file)
# puts "uploaded:", response.inspect
    root_metadata = client.metadata('/')
    puts "metadata:", root_metadata.inspect

    contents, metadata = client.get_file_and_metadata('/Grupo2/DBPrecios.accdb')
    open('DBPrecios.accdb', 'wb') {|f| f.puts contents }

# File.open('DBPrecios.accdb', 'rb') do |file|
#  print file.readline()
#  end
#database = Mdb.open 'DBPrecios.mdb'
#puts "TABLAS: "
#puts database.tables.to_s
#database[database.tables[0].to_s]
    system( "java -jar access2csv.jar DBPrecios.accdb" )

  end


  def send_tweet(message)
    require 'twitter'

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "VMskMaBDtwH11TFXvVlnrGdSr"
      config.consumer_secret     = "lILUxZ3rFEs6FamFUiRN6NISeGOTCGNuKP6w7h1Z3tg2YsyVK9"
      config.access_token        = "2567568456-ojoAMV8ui23FGYkXvFU6TTj4NLbhprZMQQ1u5v4"
      config.access_token_secret = "nefBA9qDiKcphnIfsiZqcaYzcBzTMxsAnLs3zHCLN987M"
    end

    client.update(message)
    # message debe ser producto, duracion de oferta, precio y un link. Esto cada vez que se reciba un mensaje
  end
end


  


