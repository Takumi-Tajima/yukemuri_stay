module AccommodationHelper
  def accommodation_image_tag(accommodation, variant)
    if accommodation.image.attached?
      image_tag accommodation.image.variant(variant), alt: accommodation.name, class: 'img-fluid object-fit-cover'
    else
      content_tag :div, '画像なし', class: 'text-muted'
    end
  end
end
