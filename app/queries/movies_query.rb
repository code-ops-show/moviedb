module MoviesQuery
  def self.build(keyword)
    { 
      multi_match: { 
        query: keyword,
        type: "best_fields", # possible values "most_fields", "phrase", "phrase_prefix", "cross_fields"
        fields: ["name^9", "synopsis^8", "year", "language^7", "country", "genres.name", "crews.name^10"],
        operator: "and"
      }
    }
  end

  module Aggregate
    def self.build
      { 
        crew_aggregation: {  
          nested: { path: "crews" }, 
          aggs: generate_aggregation_for("crews")
        },
        genre_aggregation: { 
          nested: { path: "genres" },
          aggs: generate_aggregation_for("genres")
        }
      }
    end

    def self.generate_aggregation_for(agg_type)
      { 
        id_and_name: { 
          terms: { script: "doc['#{agg_type}.id'].value + '|' + doc['#{agg_type}.name'].value", size: 15 }
        }
      }
    end
  end

  module Filter
    def self.build(segments)
      { 
        bool: { 
          must: nested_terms_filter(segments)
        }
      }
    end

    def self.nested_terms_filter(segments)
      segments.keys.map do |path|
        { 
          nested: { 
            path: path,
            filter: { 
              terms: { "#{path}.id": segments[path].split(',').map(&:to_i) }
            }
          }
        }
      end
    end
  end
end