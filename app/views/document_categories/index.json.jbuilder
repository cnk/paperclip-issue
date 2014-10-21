json.array!(@document_categories) do |document_category|
  json.extract! document_category, :id, :name
  json.url document_category_url(document_category, format: :json)
end
