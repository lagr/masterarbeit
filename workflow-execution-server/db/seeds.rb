
configuration = Configuration.create(
  name: 'Default Configuration',
  current: true,
  settings: {
    registry: ENV['IMAGE_REGISTRY'] || 'localhost:5000'
  }
)
