module RoomTypeHelper
  def room_type_image_tag(room_type, variant)
    if room_type.main_image.attached?
      image_tag room_type.main_image.variant(variant), alt: room_type.name, class: 'img-fluid object-fit-cover'
    else
      content_tag :div, '画像なし', class: 'text-muted'
    end
  end
end