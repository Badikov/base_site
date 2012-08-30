# ClientSideValidations Initializer

#require 'client_side_validations/simple_form' if defined?(::SimpleForm)
#require 'client_side_validations/formtastic'  if defined?(::Formtastic)

# Uncomment the following block if you want each input field to have the validation messages attached.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    %{<span class="control-group error">#{html_tag}<label for="#{instance.send(:tag_id)}" class="help-inline">#{instance.error_message.first}</label></span>}.html_safe
  else
    html_tag
  end
end

module ClientSideValidations::ActiveRecord
  module Uniqueness
    def client_side_hash(model, attribute)
      hash = {}
      hash[:message] = model.errors.generate_message(attribute, message_type, options.except(:scope))
      hash[:case_sensitive] = options[:case_sensitive]
      hash[:allow_blank] = options[:allow_blank]
      hash[:id] = model.id unless model.new_record?
      if options.key?(:scope) && options[:scope].present?
        hash[:scope] = Array.wrap(options[:scope]).inject({}) do |scope_hash, scope_item|
          scope_hash.merge!(scope_item => model.send(scope_item))
        end
      end

      unless model.class.name.demodulize == model.class.name
        hash[:class] = model.class.name.underscore
      end

      hash
    end
  end
end
