class Offer < ActiveRecord::Base
  include ApplicationHelper

  def self.get_offers
    require "bunny" # don't forget to put gem "bunny" in your Gemfile

    b = Bunny.new('amqp://ukrtynvc:AXr6Up0yW2OEs7UdxRQyLbD11RvYwm4x@hyena.rmq.cloudamqp.com/ukrtynvc')
    b.start # start a communication session with the amqp server

    q = b.queue("ofertas",:auto_delete => true) # declare a queue

# declare default direct exchange which is bound to all queues
    e = b.exchange("")
    require 'json'
    require 'date'
    msg = q.pop # get message from the queue
    while msg.last.to_s != ""
      hash = JSON[msg.last]
      sku =hash['sku']
      precio =hash['precio']
      sec = (hash['inicio'].to_s.to_f / 1000).to_s
      inicio = Date.strptime(sec, '%s')
      sec2 = (hash['fin'].to_s.to_f / 1000).to_s
      fin = Date.strptime(sec2, '%s')

      @offer = Offer.new(:sku => sku.to_s,:price => precio.to_i,:start => inicio,:end => fin,:active => false)
  ## Ver si creo Activa o Inactiva las oferta.... Cambiar Dates
      @offer.save

  ## crear oferta con estos parametros!
      msg = q.pop

    end

    b.stop # close the connection

  end

  def self.check_active
    # verificar si una oferta debe ser publicada. Primero verifico si esta activa y luego si la fecha corresponde
    Offer.all.each do |o|
      if !o.active
        if (Date.today() >= o.start && o.end>Date.today())
          #Si la fecha
          o.active = true
          msg = "OFERTA! El producto "+o.sku.to_s+" a solo $"+o.price.to_s+" desde "+o.start.to_s+" hasta el "+o.end.to_s+" #ofertagrupo2"
          send_tweet_offer(msg)
         

          
          product=Spree::Variant.where(sku: o.sku).first

          #precio_aux=  product.price
          #product.price = o.price
          #o.price= precio_aux



        end
      end
    end
  end

  def self.check_inactive
    #verifico si el periodo de oferta ya terminó
    Offer.all.each do |o|
      if o.active
        if (Date.today()> o.end)
          #Si la fecha de termino pasó
          o.active = false


          # habria q guardar el 
        
          product=Spree::Variant.where(sku: o.sku).first
          product.price = o.price

          #volver a cambiar los precios!

          ##DESTRUIR OFERTA???
        end
      end
    end
  end

  def self.send_tweet_offer(msg)

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "VMskMaBDtwH11TFXvVlnrGdSr"
      config.consumer_secret     = "lILUxZ3rFEs6FamFUiRN6NISeGOTCGNuKP6w7h1Z3tg2YsyVK9"
      config.access_token        = "2567568456-ojoAMV8ui23FGYkXvFU6TTj4NLbhprZMQQ1u5v4"
      config.access_token_secret = "nefBA9qDiKcphnIfsiZqcaYzcBzTMxsAnLs3zHCLN987M"
    end

#Ademas actualizar en caso de que sean ofertas
    client.update(msg)
    # message debe ser producto, duracion de oferta, precio y un link. Esto cada vez que se reciba un mensaje



  end

end
