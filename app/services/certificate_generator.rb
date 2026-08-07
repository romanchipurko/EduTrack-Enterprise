require "prawn"

class CertificateGenerator
  def initialize(user:, learning_path:)
    @user = user
    @learning_path = learning_path
  end

  def self.call(user:, learning_path:)
    new(user: user, learning_path: learning_path).generate
  end

  def generate
    pdf = Prawn::Document.new(page_size: "A4", page_layout: :landscape)
    pdf.bounding_box([ 50, pdf.bounds.height - 50 ], width: pdf.bounds.width - 100, height: pdf.bounds.height - 100) do
      pdf.stroke_bounds
      pdf.move_down 70
      pdf.font_size 36
      pdf.text "Certificate of Completion", align: :center, style: :bold
      pdf.move_down 40
      pdf.font_size 18
      pdf.text "This is to certify that", align: :center
      pdf.move_down 20
      pdf.font_size 28
      pdf.text @user.email, align: :center, style: :bold
      pdf.move_down 20
      pdf.font_size 18
      pdf.text "has successfully completed the learning path", align: :center
      pdf.move_down 20
      pdf.font_size 28
      pdf.text @learning_path.title, align: :center, style: :bold
      pdf.move_down 60
      pdf.font_size 14
      pdf.text "Date: #{Date.current.strftime('%B %d, %Y')}", align: :center
    end

    pdf.render
  end
end
