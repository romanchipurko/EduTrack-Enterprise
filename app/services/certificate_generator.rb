require "prawn"

class CertificateGenerator
  def initialize(user:, learning_path:, locale: I18n.default_locale)
    @user = user
    @learning_path = learning_path
    @locale = locale
  end

  def self.call(user:, learning_path:, locale: I18n.default_locale)
    new(user: user, learning_path: learning_path, locale: locale).generate
  end

  def generate
    I18n.with_locale(@locale) do
      pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape)

      font_path = Rails.root.join("lib", "fonts")
      pdf.font_families.update("Roboto" => {
        normal: font_path.join("Roboto-Regular.ttf").to_s,
        bold: font_path.join("Roboto-Bold.ttf").to_s
      })
      pdf.font "Roboto"

      pdf.bounding_box([ 50, pdf.bounds.height - 50 ], width: pdf.bounds.width - 100, height: pdf.bounds.height - 100) do
        pdf.stroke_bounds

        pdf.move_down 40
        pdf.text I18n.t("certificate.title"), align: :center, size: 32, style: :bold

        pdf.move_down 30
        pdf.text I18n.t("certificate.certify_that"), align: :center, size: 16

        pdf.move_down 15
        pdf.text_box @user.email,
                     at: [ 0, pdf.cursor ], width: pdf.bounds.width, height: 35,
                     align: :center, size: 24, style: :bold, overflow: :shrink_to_fit
        pdf.move_down 35

        pdf.move_down 15
        pdf.text I18n.t("certificate.completed"), align: :center, size: 16

        pdf.move_down 15
        pdf.text_box @learning_path.title,
                     at: [ 20, pdf.cursor ], width: pdf.bounds.width - 40, height: 60,
                     align: :center, size: 24, style: :bold, overflow: :shrink_to_fit
        pdf.move_down 60

        pdf.move_down 35
        formatted_date = I18n.l(Date.current, format: :long)
        pdf.text I18n.t("certificate.date", date: formatted_date), align: :center, size: 14
      end

      pdf.render
    end
  end
end
