module ImageSettings
  MAIN_IMAGE = {
    content_type: %i[png jpg jpeg],
    max_size: 5.megabytes,
    thumbnail_size: [300, 300],
    display_size: [600, 600],
  }.freeze
end
