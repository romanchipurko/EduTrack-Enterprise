class CertificateGenerationJob < ApplicationJob
  queue_as :default

  def perform(user:, learning_path:)
    @user = user
    @learning_path = learning_path
    @enrollment = Enrollment.find_by(user: @user, learning_path: @learning_path)
    return unless @user && @learning_path && @enrollment

    save_certificate(pdf_data: CertificateGenerator.call(user: @user, learning_path: @learning_path))
  end

  private

  def save_certificate(pdf_data:)
    @enrollment.certificate.attach(
      io: StringIO.new(pdf_data),
      filename: "certificate_#{@user.id}_#{@learning_path.id}.pdf",
      content_type: "application/pdf"
    )
  end
end
