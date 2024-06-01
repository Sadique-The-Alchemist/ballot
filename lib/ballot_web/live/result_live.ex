defmodule BallotWeb.ResultLive do
  use BallotWeb, :live_view
  alias Ballot.Poll

  def mount(%{"vote_id" => vote_id}, _session, socket) do
    result = Poll.get_votes(vote_id)
    labels = Jason.encode!(Map.keys(result))
    data = Jason.encode!(Map.values(result))
    socket = socket |> assign(:labels, labels) |> assign(:data, data)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h3>Result</h3>
      <div
        x-data={"{chart: null, labels: #{@labels}, data: #{@data} }"}
        x-init="
      chart = new Chart(document.getElementById('result'), {
      type: 'pie',
      options: {
            responsive: false,
          },
      data: {
        labels: labels ,
        datasets: [{
          label: 'My First Dataset',
          data:  data ,
          backgroundColor: [
            'rgb(255, 99, 132)',
            'rgb(54, 162, 235)',
            'rgb(255, 205, 86)',
            'rgb(95, 205, 86)',
          ],
          hoverOffset: 4
        }],

      }
      ,
     })
     "
      >
        <canvas id="result"></canvas>
      </div>
    </div>
    """
  end
end
