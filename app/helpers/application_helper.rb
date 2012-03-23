#encoding: utf-8
module ApplicationHelper
  def error_div(model, field, field_name)
    return unless model
    field = field.is_a?(Symbol) ? field.to_s : field
    errors = model.errors[field]
    return unless errors
    %Q(
    #{errors.is_a?(Array) ? errors.map{|e| field_name + e}.join(",") : field_name << errors}
    )
  end
end
