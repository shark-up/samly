defmodule Samly.AuthRouter do
  @moduledoc false

  use Plug.Router
  import Plug.Conn
  import Samly.RouterUtil, only: [check_idp_id: 2, check_target_url: 2]

  plug :fetch_session
  # plug Plug.CSRFProtection
  plug :match
  plug :check_idp_id
  plug :check_target_url
  plug :dispatch

  scope "/signin" do
    plug Plug.CSRFProtection

    get "/*idp_id_seg" do
      conn |> Samly.AuthHandler.initiate_sso_req()
    end

    post "/*idp_id_seg" do
      conn |> Samly.AuthHandler.send_signin_req()
    end
  end

  scope "/signout" do
    get "/*idp_id_seg" do
      conn |> Samly.AuthHandler.initiate_sso_req()
    end

    post "/*idp_id_seg" do
      conn |> Samly.AuthHandler.send_signout_req()
    end
  end

  match _ do
    conn |> send_resp(404, "not_found")
  end
end
