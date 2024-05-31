defmodule BallotWeb.ResultLive do
  use BallotWeb, :live_view
  alias Ballot.Poll
  def mount(%{"vote_id"=> vote_id}, _session, socket) do

    result = Poll.get_votes(vote_id)

    IO.inspect(result)
    {:ok, socket}
  end
  def render(assigns) do
    ~H"""
    <div>
     <h3>Result</h3>
     <div class = "w-96 h-96" x-data="{chart: null}" x-init="
      chart = new Chart(document.getElementById('result'), {
      type: 'pie',
      data: {
        labels: [
          'Red',
          'Blue',
          'Yellow'
        ],
        datasets: [{
          label: 'My First Dataset',
          data: [300, 50, 100],
          backgroundColor: [
            'rgb(255, 99, 132)',
            'rgb(54, 162, 235)',
            'rgb(255, 205, 86)'
          ],
          hoverOffset: 4
        }]
      }
      ,
     })
     ">
     <canvas id="result" ></canvas>
     </div>
    </div>
    """
  end
end
