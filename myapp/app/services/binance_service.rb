class BinanceService
  def initialize
    @last_price = nil
  end

  def latest_price
    start_ws
    wait_for_price_update
    stop_ws
    @last_price
  end

  private

  def start_ws
    @ws = Faye::WebSocket::Client.new('wss://stream.binance.com:9443/ws/btcusdt@trade')
    @ws.on :message do |event|
      data = JSON.parse(event.data)
      @last_price = data['p']
    end
  end

  def wait_for_price_update
    sleep 5
  end

  def stop_ws
    @ws.close if @ws
  end
end
