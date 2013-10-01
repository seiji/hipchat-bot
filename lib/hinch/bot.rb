require 'hinch/helpers'
require 'ostruct'
require 'xmpp4r/muc/helper/simplemucclient'

module Hinch
  class Bot
    include Helpers
    attr_accessor :config, :client, :muc

    def initialize(&b)
      @config = OpenStruct.new(
                               :server => 'chat-a1.hipcaht.com',
                               :nick   => 'bot',
                               )
      instance_eval(&b) if block_given?
      exit unless @config.jid
      @client = Jabber::Client.new @config.jid
      @muc    = Jabber::MUC::SimpleMUCClient.new @client
      if Jabber.logger == @config.debug
        Jabber.debug = true
      end
      self
    end

    def configure
      yield @config
    end

    def connect
      @client.connect
      @client.auth(config.password)
      @client.send(Jabber::Presence.new.set_type(:available))

      mention = @config.nick.split(/\s+/).first

      @muc.on_message do |time, nick, text|
        next unless text =~ /^@?#{mention}:*\s+(.+)$/i or text =~ /^!(.+)$/
        begin
          process(nick, $1)
        rescue => e
          warn "exception: #{e.inspect}"
        end
      end
      @muc.join(config.room + '/' + config.nick)
      self
    end

    def process(from, command)
      warn "command: #{from}> #{command}"
      firstname = from.split(/ /).first

      case command
      when /^echo\s+([^\s].*)$/ then
        respond "#{from}: #{$1}"
      else
      end
    end

    def respond(msg)
      muc.send Jabber::Message.new(muc.room, msg)
    end

    def run
      warn "running"
      loop do
        sleep 1
#        respond 'hello'
      end
    end
  end
end
