defmodule Todo do
  # Check if todo file exist, if is not, create it with an empty list
  def init do
    get_path()
    |> file_exist?()
  end

  defp get_path do
    with {:ok, path} = File.cwd() do
      Path.join(path, "todo")
    end
  end

  defp file_exist?(file) do
    unless File.exists?(file) do
      :ok = create_file(file)
      {:ok, "TODO file created succesfully."}
    end
    :ok
  end

  defp create_file(path) do
    with content = encode_content([]),
         :ok = File.write(path, content) do
      :ok
    end
  end

  defp encode_content(content) do
    :erlang.term_to_binary(content)
  end

  defp decode_content(binary) do
    :erlang.binary_to_term(binary)
  end

  def create_task(date, name, description, status) do
    ensamble_task(date, name, description, status)
    |> append_task()
  end

  def get() do
    with path = get_path(),
         {:ok, binary} = File.read(path) do
      decode_content(binary)
    end
  end

  defp ensamble_task(date, name, description, status) do
    %{
      date: date,
      name: name,
      description: description,
      status: status
    }
  end

  defp append_task(task) do
    with path            = get_path(),
         # Open file
         {:ok, binary}     = File.read(path),
         # Decode file
         task_list       = decode_content(binary),
         # append task
         new_task_list   = [task | task_list],
         # encode new list
         new_list_binary = encode_content(new_task_list),
         # append new binary to file
         :ok             = append_content(path, new_list_binary) do
      {:ok, "Task created succesfully."}
    end
  end

  defp append_content(path, content) do
    File.write(path, content)
  end
end

# date, name, description, status
