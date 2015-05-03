module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      error:   'alert-danger',
      alert:   'alert-warning',
      notice:  'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def nav_link(text, link, options={}, &block)
    if recognized = Rails.application.routes.recognize_path(link) rescue nil
      class_name = recognized[:controller] == params[:controller] ? 'active' : ''
    end
    content = block_given? ? capture(&block) : ''
    content_tag(:li, options.merge({class: class_name})) do
      link_to link do
        content + text
      end
    end
  end

  def delete_action(resource)
    link_to([:admin, resource],
      data: {
        confirm: 'Are you sure?',
        toggle: 'tooltip', placement: 'left'
      },
      title: 'Delete',
      method: :delete,
      id: :delete
    ) do
      content_tag(:i, nil, class: 'glyphicon glyphicon-trash')
    end
  end

  def footer_links
    content_tag(:ul, class: 'list-inline') do
      STATIC_PAGES.map do |p|
        concat content_tag(:li, link_to(p.humanize, "/#{p}"))
      end
    end
  end
end
