class AggregationPresenter < Struct.new(:aggregation)
  def name
    aggregation.first.split('_').first.pluralize.titleize
  end

  def kind
    aggregation.first.split('_').first.pluralize
  end

  def buckets
    aggregation[1].id_and_name.buckets.map{ |b| BucketPresenter.new(b) }
  end
end