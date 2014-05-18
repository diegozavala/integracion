require 'test_helper'

class FtpPedidosControllerTest < ActionController::TestCase
  setup do
    @ftp_pedido = ftp_pedidos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ftp_pedidos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ftp_pedido" do
    assert_difference('FtpPedido.count') do
      post :create, ftp_pedido: { fecha_procesado: @ftp_pedido.fecha_procesado, nombre_archivo: @ftp_pedido.nombre_archivo, numero_pedido: @ftp_pedido.numero_pedido }
    end

    assert_redirected_to ftp_pedido_path(assigns(:ftp_pedido))
  end

  test "should show ftp_pedido" do
    get :show, id: @ftp_pedido
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ftp_pedido
    assert_response :success
  end

  test "should update ftp_pedido" do
    patch :update, id: @ftp_pedido, ftp_pedido: { fecha_procesado: @ftp_pedido.fecha_procesado, nombre_archivo: @ftp_pedido.nombre_archivo, numero_pedido: @ftp_pedido.numero_pedido }
    assert_redirected_to ftp_pedido_path(assigns(:ftp_pedido))
  end

  test "should destroy ftp_pedido" do
    assert_difference('FtpPedido.count', -1) do
      delete :destroy, id: @ftp_pedido
    end

    assert_redirected_to ftp_pedidos_path
  end
end
