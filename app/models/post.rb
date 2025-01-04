class Post < ApplicationRecord
    has_rich_text :content

    validates :title, length: { maximum: 32  }, presence: true

    validate :validate_content_max_register
    validate :validate_content_length
    validate :validate_content_attachment_byte_size


    MAX_CONTENT_LENGTH = 80
    ONE_KILOBYTE = 1024
    MEGA_BYTES = 3
    MAX_CONTENT_ATTACHEMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE
    MAX_CONTENT_REGISTER = 4

    private

    def validate_content_max_register
    count = content.body.attachables.grep(ActiveStorage::Blob).size
    if count > MAX_CONTENT_REGISTER
      errors.add(
        :base,
        :content_registers_size_is_too_big,
        registers: count,
        max_registers: MAX_CONTENT_REGISTER
      )
    end
    end


    def validate_content_attachment_byte_size
        content.body.attachables.grep(ActiveStorage::Blob).each do |attachable|
        if attachable.byte_size > MAX_CONTENT_ATTACHEMENT_BYTE_SIZE
         errors.add(
            :base,
            :content_attachment_byte_size_is_too_big,
            max_content_attachment_mega_byte_size: MEGA_BYTES,
            bytes:  attachable.byte_size,
            max_bytes: MAX_CONTENT_ATTACHEMENT_BYTE_SIZE
          )
        end
        end
    end


    def validate_content_length
        length = content.to_plain_text.length

        if length > MAX_CONTENT_LENGTH
        errors.add(:content,
         :too_long,
         max_content_length: MAX_CONTENT_LENGTH,
        length: length
          )
        end
    end
end
