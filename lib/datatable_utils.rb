require 'datatable_utils/array'

module DatatableUtils
  def self.included(base)
    base.class_eval do
      delegate :params, :h, :l, :link_to, to: :@view
    end
  end

  def initialize(view, collection, controller = nil)
    @view = view
    @collection = collection
    @controller = controller
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: records_count,
      iTotalDisplayRecords: (paginate? ? cached_collection.total_entries : records_count),
      aaData: data
    }
  end

  private

  def data
    cached_collection.map do |objekt|
      data_proc.call objekt
    end
  end

  def cached_collection
    @cached_collection ||= fetch_collection
  end

  def order_default
    ''
  end

  def fetch_collection
    collection = @collection.where(columns_search).order(sort)

    if paginate?
      collection = collection.page(page).per_page(per_page)
    end

    if params[:search].present? and params[:search][:value].present?
      collection = collection.search(params[:search][:value])
    end
    collection
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def paginate?
    params[:length].to_i > 0
  end

  def records_count
    @records_count ||= @collection.count
  end

  def sort
    if params[:order]
      params.permit(order:{})[:order].to_h.each_value.map do |order|
        "#{columns[order['column'].to_i]} #{order['dir']}"
      end.join(', ')
    else
      order_default
    end
  end

  def columns_search
    if params[:columns]
      search_hash = params.permit(columns:{})[:columns].to_h.select{|_, v| v['search']['value'].present?}
      search_hash.each.map do |i, param|
        "#{columns_for_search[i.to_i]} ILIKE '%#{param['search']['value']}%'"
      end.join(' AND ')
    end
  end

  def condition_map
    return Array.new(11, true) if self.is_a?(RequestsDatatable)

    [true, true, true, true, @params[:company_type_sufix] != '', true, true, true, true]
  end

  def columns
    condition_map ? self.class::COLUMNS.filter(condition_map) : self.class::COLUMNS
  end

  def columns_for_search
    condition_map ? self.class::COLUMNS_FOR_SEARCH.filter(condition_map) :
      self.class::COLUMNS_FOR_SEARCH
  end
end
