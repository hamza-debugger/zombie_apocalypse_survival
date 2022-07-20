defmodule ZombieApocalypseSurvivalWeb.TradeController do
  use ZombieApocalypseSurvivalWeb, :controller
  # alias ZombieApocalypseSurvivalWeb.AuthController
  alias ZombieApocalypseSurvival.{
    ResourceManager,
    SurvivorManager,
    TradeManager,
    TradeManager.Trade,
    ResourceManager.Resource,
    Auth.Guardian
  }


  def create(conn, %{"id" => id,"resource" => resource} = params) do
      IO.inspect(params, label: "create========================")
      current_resource = Guardian.Plug.current_resource(conn)

     if String.to_integer(id) != current_resource.id do

     if check_availability(resource["to_exchange_resource"], resource["to_exchange_quantity"], current_resource.id) and check_availability(resource["by_exchange_resource"], resource["by_exchange_quantity"], id) do

           params_to = params_to_helper({resource["to_exchange_resource"], String.to_integer(resource["to_exchange_quantity"])}) |> Map.put(:trade_to_id, current_resource.id)
           params_by = params_by_helper({resource["by_exchange_resource"], String.to_integer(resource["by_exchange_quantity"])}) |> Map.put(:trade_by_id, String.to_integer(id))

           params = Map.merge(params_to, params_by) |> Map.put(:status, :pending)

           IO.inspect(params, label: "After helper===========")
      case TradeManager.trade_with_resource(String.to_atom(resource["to_exchange_resource"]), current_resource.id)|> IO.inspect(label: "trade with resourceee===========") do
        nil ->  case TradeManager.create_trade(params) do
          {:ok, _} ->  conn
                       |> put_flash(:info, "Your Trade Request Have been Sent!")
                       |> redirect(to: "/survivors")
           {:error, _}->
                 conn
                |> put_flash(:error, "Somthing went wrong Try Again")
                |> redirect(to: "/resource/#{String.to_integer(id)}")
         end

        _trade ->  conn
                  |> put_flash(:error, "Your Request has already been sent")
                  |> redirect(to: "/resource/#{String.to_integer(id)}")

      end

     else
      conn
      |> put_flash(:error, "The Resource Quantity You Entered is not available. Kindly Check the availability Tables")
      |> redirect(to: "/resource/#{String.to_integer(id)}" , survivor: current_resource)
     end
     
    else
      IO.inspect("norrrrrr")
      conn
      |> put_flash(:error, "You Cannot Trade With Yourself")
      |> redirect(to: "/resource/#{String.to_integer(id)}")
    end
  end




  def params_to_helper(resource) do
    case resource do
      {"ak47", quantity} ->
        %{
          to_resource_type: :ak47,
          to_quantity: quantity,
          to_total_points: quantity * 8
        }

      {"campbell_soup", quantity} ->
        %{
          to_resource_type: :campbell_soup,
          to_quantity: quantity,
          to_total_points: quantity * 12
        }

      {"fiji_water", quantity} ->
        %{
          to_resource_type: :fiji_water,
          to_quantity: quantity,
          to_total_points: quantity * 14
        }

      {"first_aid_pouch", quantity} ->
        %{
          to_resource_type: :first_aid_pouch,
          to_quantity: quantity,
          to_total_points: quantity * 10
        }

      _ ->
        %{}
    end

  end


  def params_by_helper(resource) do
    case resource do
      {"ak47", quantity} ->
        %{
          by_resource_type: :ak47,
          by_quantity: quantity,
          by_total_points: quantity * 8
        }

      {"campbell_soup", quantity} ->
        %{
          by_resource_type: :campbell_soup,
          by_quantity: quantity,
          by_total_points: quantity * 12
        }

      {"fiji_water", quantity} ->
        %{
          by_resource_type: :fiji_water,
          by_quantity: quantity,
          by_total_points: quantity * 14
        }

      {"first_aid_pouch", quantity} ->
        %{
          by_resource_type: :first_aid_pouch,
          by_quantity: quantity,
          by_total_points: quantity * 10
        }

      _ ->
        %{}
    end

  end


  def check_availability(given_resource_type, given_quantity, survivor_id) do
    IO.inspect( given_resource_type,label: "given_resource_type")
    IO.inspect( given_quantity,label: "given_quantity")
    case ResourceManager.get_resource_by_resource_type(given_resource_type, survivor_id) |> IO.inspect(label: "get_resource_by_resource_type") do
      nil -> false
      %{resource_type: resource_type, quantity: quantity} = return -> IO.inspect(return, label: "sdsd")
      if (Atom.to_string(resource_type) == given_resource_type and quantity >= String.to_integer(given_quantity)) |> IO.inspect(label: "iffff"), do: true, else: false
    end
  end





  def show_requests(conn, _params) do
    IO.inspect("request bro================")
    current_resource = Guardian.Plug.current_resource(conn)
    case TradeManager.get_trade_by(current_resource.id) |> IO.inspect(label: "get_trade_by")do
      [] -> conn
            |> put_flash(:info, "Your have no request yet!")
            |> redirect(to: "/survivors")

      trades -> IO.inspect(trades, label: "tradess")
        render(conn, "all_requests.html", trades: trades)
    end
  end





  def accept_request(conn, %{"id" => id}) do
    current_resource = Guardian.Plug.current_resource(conn)
    case TradeManager.get_trade!(String.to_integer(id)) |> IO.inspect(label: "get00000000")do
      trade = %Trade{} ->  if accept_check_availability(trade.to_resource_type, trade.to_quantity, current_resource.id) and
                                     accept_check_availability(trade.by_resource_type, trade.by_quantity, trade.trade_by_id) |> IO.inspect(label: "Check")do
                                  exchange_resources_done(conn, trade)|> IO.inspect(label: "+++++++++++++")
                            else
                                  conn
                                  |> put_flash(:error, "The Resource Quantity You Entered is not available.")
                                  |> redirect(to: "/survivors")
                            end
      _error -> conn
      |> put_flash(:info, "Your trade has been cancelled!")
      |> redirect(to: "/survivors")
    end
  end

  def reject_request(conn, %{"id" => id}) do
    current_resource = Guardian.Plug.current_resource(conn)
    case TradeManager.get_trade_by_current_user(id, current_resource.id) do
      nil ->
            conn
            |> put_flash(:info, "Your trade has been cancelled!")
            |> redirect(to: "/survivors")

      trade ->  TradeManager.update_trade(trade, %{status: :reject})
      conn
      |> put_flash(:info, "Trade has been rejected")
      |> redirect(to: "/survivors")
    end


  end


  def accept_check_availability(given_resource_type, given_quantity, survivor_id) do
    IO.inspect( given_resource_type,label: "given_resource_type")
    IO.inspect( given_quantity,label: "given_quantity")
    case ResourceManager.get_resource_by_resource_type(given_resource_type, survivor_id) |> IO.inspect(label: "get_resource_by_resource_type") do
      nil -> false
      %{resource_type: resource_type, quantity: quantity} = return -> IO.inspect(return, label: "return")
      if (resource_type == given_resource_type and quantity >= given_quantity) |> IO.inspect(label: "if_go"), do: true, else: false
    end
  end

  def exchange_resources_done(conn, trade) do
    IO.inspect( trade,label: "tradeeeeeeeeeeeeeeee")
    with  minus_to_resources <- ResourceManager.get_resource_by_resource_type(trade.to_resource_type, trade.trade_to_id) |> IO.inspect(label: "minus_to_resources"),
          minus_by_resources <- ResourceManager.get_resource_by_resource_type(trade.by_resource_type, trade.trade_by_id) |> IO.inspect(label: "minus_by_resources"),
          add_to_resources <- ResourceManager.get_resource_by_resource_type(trade.by_resource_type, trade.trade_to_id) |> IO.inspect(label: "add_to_resources"),
          add_by_resources <- ResourceManager.get_resource_by_resource_type(trade.to_resource_type, trade.trade_by_id) |> IO.inspect(label: "add_by_resources")
           do
            if trade.to_total_points >= trade.by_total_points |> IO.inspect(label: "pointsss") do
              IO.inspect("@@@@@@@@@@@@@@@@@@@@@@@")
              update_req_to_minus_params = %{quantity: minus_to_resources.quantity - trade.to_quantity, total_points: minus_to_resources.total_points - trade.by_total_points}
              update_req_to_add_params = %{quantity: add_to_resources.quantity + trade.to_quantity, total_points: add_to_resources.total_points + trade.by_total_points}
              update_req_by_minus_params = %{quantity: minus_by_resources.quantity - trade.by_quantity, total_points: minus_by_resources.total_points - trade.by_total_points}
              update_req_by_add_params = %{quantity: add_by_resources.quantity + trade.by_quantity, total_points: add_by_resources.total_points + trade.by_total_points}

              ResourceManager.update_resource(minus_to_resources, update_req_to_minus_params)
              ResourceManager.update_resource(add_to_resources, update_req_to_add_params)
              ResourceManager.update_resource(minus_by_resources, update_req_by_minus_params)
              ResourceManager.update_resource(add_by_resources, update_req_by_add_params)

              TradeManager.update_trade(trade, %{status: :accept})
              conn
              |> put_flash(:info, "Trade Done Successfully")
              |> redirect(to: "/survivors")
            else
              TradeManager.update_trade(trade, %{status: :reject})
              conn
              |> put_flash(:error, "I prefer to change things but your points are low  for this Exchange. So Trade  Got Rejected")
              |> redirect(to: "/survivors")
            end

    end
  end




end
