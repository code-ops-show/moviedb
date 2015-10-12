class IndexerJob < ActiveJob::Base
  queue_as :elasticsearch

  def perform(operation, record_id)
    logger.debug [operation, "Movie: #{record_id}"]
    self.send(operation, record_id)
  end

private

  def index(record_id)
    record = Movie.find(record_id) 
    record.__elasticsearch__.index_document
  end

  def delete(record_id)
    record = Movie.find(record_id)
    record.__elasticsearch__.delete_document
  end
end
