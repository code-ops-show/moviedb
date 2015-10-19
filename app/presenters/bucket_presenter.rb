class BucketPresenter < Struct.new(:bucket)
  def id
    bucket['key'].split('|').first
  end

  def name
    bucket['key'].split('|').last
  end

  def count
    bucket['doc_count']
  end
end