require_relative './file_io'

class Repository
  def inspect
    "#<#{self.class} #{@models.size} rows>"
  end

  def load_models(filename, model_class_name)
    @models = FileIo.process_csv(filename, model_class_name)
  end

  def all
    @models
  end

  def find_max_id
    @models.max_by(&:id).id
  end

  def find_by_id(id)
    @models.find { |model| model.id == id }
  end

  def find_by
    @models.find do |model|
      yield(model) if block_given?
    end
  end

  def find_all_by
    @models.find_all do |model|
      yield(model) if block_given?
    end
  end

  def create(model)
    model.update_id(find_max_id + 1)
    @models << model
  end

  def update(id, _attributes)
    model = find_by_id(id)
    unless model.nil?
      yield(model) if block_given?
      model.update_time
    end
  end

  def delete(id)
    model = find_by_id(id)
    @models.delete(model)
  end
end
