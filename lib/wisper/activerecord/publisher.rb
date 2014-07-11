module Wisper
  module Activerecord
    module Publisher
      extend ActiveSupport::Concern
      included do

        include Wisper::Publisher

        after_commit :publish_creation, on: :create
        after_commit :publish_update, on: :update
        after_commit :publish_destroy, on: :destroy
        after_validation :publish_creation_failed, on: :create
        after_validation :publish_update_failed, on: :update
        after_validation :publish_destroy_failed, on: :destroy
      end

      private

      def publish_creation
        broadcast("#{self.class.name.underscore}_created", self)
      end

      def publish_update
        broadcast("#{self.class.name.underscore}_updated", self)
      end

      def publish_destroy
        broadcast("#{self.class.name.underscore}_destroyed", self)
      end

      def publish_creation_failed
        broadcast("#{self.class.name.underscore}_create_failed", self) if errors.any?
      end

      def publish_update_failed
        broadcast("#{self.class.name.underscore}_update_failed", self) if errors.any?
      end

      def publish_destroy_failed
        broadcast("#{self.class.name.underscore}_destroy_failed", self) if errors.any?
      end
    end
  end
end
