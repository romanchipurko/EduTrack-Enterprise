class CertificateGenerationJob < ApplicationJob
  queue_as :certificate_generation

  def perform(user:, learning_path:, locale:)
    return unless (enrollment = Enrollment.find_by(user: user, learning_path: learning_path))

    enrollment.with_lock do
      return if enrollment.certificate.attached?

      save_certificate(
          enrollment: enrollment,
          pdf_data: CertificateGenerator.call(user: user, learning_path: learning_path, locale: locale),
          filename: "certificate_#{user.id}_#{learning_path.id}.pdf",
        )
    end
  end

  private

  def save_certificate(enrollment:, pdf_data:, filename:)
    enrollment.certificate.attach(
      io: StringIO.new(pdf_data),
      filename: filename,
      content_type: "application/pdf"
    )
  end
end
