require_relative 'spec_helper_lite'

module SpecHelpers
  def setup_database
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  def teardown_database
    DatabaseCleaner.clean
  end
end
