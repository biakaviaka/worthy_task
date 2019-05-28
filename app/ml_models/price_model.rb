# https://github.com/ankane/eps
class PriceModel < Eps::Base
  # def predict_price(carat, shape, color, clarity)
  #   pmml = File.read("model.pmml")
  #   model = Eps::Model.load_pmml(pmml)
  #
  #   model.predict(carat: carat, shape: shape, color: color, clarity: clarity)
  # end

  def build
    deals = RecentDeals.all.to_a

    # divide into training and test set
    rng = Random.new(1) # seed random number generator
    train_set, test_set = deals.partition { rng.rand < 0.7 }

    # handle outliers and missing values
    train_set = preprocess(train_set)

    # train
    train_features = train_set.map { |v| features(v) }
    train_target = train_set.map { |v| target(v) }
    model = Eps::Model.new(train_features, train_target)

    # evaluate
    test_features = test_set.map { |v| features(v) }
    test_target = test_set.map { |v| target(v) }
    metrics = model.evaluate(test_features, test_target)
    puts metrics.inspect

    # finalize
    deals = preprocess(deals)
    all_features = deals.map { |h| features(h) }
    all_target = deals.map { |h| target(h) }
    model = Eps::Model.new(all_features, all_target)

    # save
    File.write(model_file, model.to_pmml)
    @model = nil # reset for future predictions
  end

  def predict(deal)
    model.predict(features(deal))
  end

  private

  def preprocess(train_set)
    train_set.reject do |h|
      (SHAPE.exclude? h.shape) || (COLOR.exclude? h.color) || (CLARITY.exclude? h.clarity) || h.price.nil?
    end
  end

  def features(deal)
    {
        shape: deal.shape,
        clarity: deal.clarity,
        color: deal.color,
        carat_weight: deal.carat_weight
    }
  end

  def target(deal)
    deal.price
  end

  def model
    @model ||= Eps::Model.load_pmml(File.read(model_file))
  end

  def model_file
    File.join(__dir__, "price_model.pmml")
  end
end