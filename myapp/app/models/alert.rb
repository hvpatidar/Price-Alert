class Alert < ApplicationRecord
  require 'net/smtp'

  belongs_to :user

  enum status: %i[created triggered deleted]

  validates :coin, :target_price, presence: true

  after_save :check_price

  def check_price
    latest_price = BinanceService.new.latest_price
    if latest_price >= target_price
      update(status: :triggered)
      send_alert_email
    end
  end

  def send_alert_email
    from = 'your-email@gmail.com'
    password = 'your-gmail-password'
    to = user.email
    subject = "Price alert triggered for #{coin}!"

    body = "Hello,\n\nYour price alert for #{coin} has been triggered! The current price is #{BinanceService.new.latest_price}.\n\nBest,\nThe Price Alert Bot"

    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls
    smtp.start('gmail.com', from, password, :login) do |smtp|
      smtp.send_message(body, from, to, subject)
    end
  end
end
