module ApiHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def assert_not_found!
    expect(response.status).to eq(404)
    expect(json_response[:message]).to eq('The record you were looking for could not be found.')
  end
end
