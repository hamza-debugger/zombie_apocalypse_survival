defmodule ZombieApocalypseSurvival.SurvivorManagerTest do
  use ZombieApocalypseSurvival.DataCase

  alias ZombieApocalypseSurvival.SurvivorManager

  describe "survivors" do
    alias ZombieApocalypseSurvival.SurvivorManager.Survivor

    import ZombieApocalypseSurvival.SurvivorManagerFixtures

    @invalid_attrs %{age: nil, gender: nil, name: nil, password: nil}

    test "list_survivors/0 returns all survivors" do
      survivor = survivor_fixture()
      assert SurvivorManager.list_survivors() == [survivor]
    end

    test "get_survivor!/1 returns the survivor with given id" do
      survivor = survivor_fixture()
      assert SurvivorManager.get_survivor!(survivor.id) == survivor
    end

    test "create_survivor/1 with valid data creates a survivor" do
      valid_attrs = %{
        age: 42,
        gender: "some gender",
        name: "some name",
        password: "some password"
      }

      assert {:ok, %Survivor{} = survivor} = SurvivorManager.create_survivor(valid_attrs)
      assert survivor.age == 42
      assert survivor.gender == "some gender"
      assert survivor.name == "some name"
      assert survivor.password == "some password"
    end

    test "create_survivor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SurvivorManager.create_survivor(@invalid_attrs)
    end

    test "update_survivor/2 with valid data updates the survivor" do
      survivor = survivor_fixture()

      update_attrs = %{
        age: 43,
        gender: "some updated gender",
        name: "some updated name",
        password: "some updated password"
      }

      assert {:ok, %Survivor{} = survivor} =
               SurvivorManager.update_survivor(survivor, update_attrs)

      assert survivor.age == 43
      assert survivor.gender == "some updated gender"
      assert survivor.name == "some updated name"
      assert survivor.password == "some updated password"
    end

    test "update_survivor/2 with invalid data returns error changeset" do
      survivor = survivor_fixture()

      assert {:error, %Ecto.Changeset{}} =
               SurvivorManager.update_survivor(survivor, @invalid_attrs)

      assert survivor == SurvivorManager.get_survivor!(survivor.id)
    end

    test "delete_survivor/1 deletes the survivor" do
      survivor = survivor_fixture()
      assert {:ok, %Survivor{}} = SurvivorManager.delete_survivor(survivor)
      assert_raise Ecto.NoResultsError, fn -> SurvivorManager.get_survivor!(survivor.id) end
    end

    test "change_survivor/1 returns a survivor changeset" do
      survivor = survivor_fixture()
      assert %Ecto.Changeset{} = SurvivorManager.change_survivor(survivor)
    end
  end
end
