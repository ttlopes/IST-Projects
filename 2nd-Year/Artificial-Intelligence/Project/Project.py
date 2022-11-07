# ----------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Artificial Intelligence
# ----------------------------------


from sys import stdin
import numpy as np

from Search import (
    Problem,
    Node,
    astar_search,  # this
    breadth_first_tree_search,
    depth_first_tree_search,
    greedy_search,  # this
    recursive_best_first_search,
)


class TakuzuState:
    state_id = 0

    def __init__(self, board):
        self.board = board
        self.id = TakuzuState.state_id
        TakuzuState.state_id += 1

    def __lt__(self, other):
        return self.id < other.id

    # TODO: outros metodos da classe


class Board:
    """Representação interna de um tabuleiro de Takuzu."""

    def __init__(self, board, size, available_positions):
        self.value = board
        self.size = size
        self.available_positions = available_positions

    def __repr__(self):
        """Representação do tabuleiro."""
        s = ""
        for i in range(self.size):
            for j in range(self.size):
                s += str(self.get_number(i, j)) + "\t"
            s = s[:-1] + "\n"
        return s

    def get_number(self, row: int, col: int) -> int:
        """Devolve o valor na respetiva posição do tabuleiro."""
        # TODO
        if row < 0 or row >= self.size or col < 0 or col >= self.size:
            return None
        return self.value[row][col]

    def adjacent_vertical_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os valores imediatamente abaixo e acima,
        respectivamente."""
        # TODO
        return (
            None if row == self.size - 1 else self.value[row + 1][col],
            None if row == 0 else self.value[row - 1][col],
        )

    def adjacent_horizontal_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os valores imediatamente à esquerda e à direita,
        respectivamente."""
        # TODO
        return (
            None if col == 0 else self.value[row][col - 1],
            None if col == self.size - 1 else self.value[row][col + 1],
        )

    @staticmethod
    def parse_instance_from_stdin():
        """Lê o test do standard input (stdin) que é passado como argumento
        e retorna uma instância da classe Board."""
        size = int(stdin.readline())
        input = Board([], size, -1)
        avaliable_positions = pow(size, 2)

        board = []
        for _ in range(input.size):
            board.append([])
            for x in stdin.readline():
                if x != "\t" and x != "\n":
                    board[-1].append(int(x))
                    if int(x) != 2:
                        avaliable_positions -= 1

        input.value = board
        input.available_positions = avaliable_positions
        return Board(board, size, avaliable_positions)


class Takuzu(Problem):
    def __init__(self, board: Board):
        """O construtor especifica o estado inicial."""
        initial_state = TakuzuState(board)
        super().__init__(initial_state)
        self.size = board.size

    def canPlay(self, state: TakuzuState, action):
        """Retorna True se o estado passado como argumento pode ser
        jogado, False caso contrário."""

        size = state.board.size
        copied_value = list(np.copy(state.board.value))
        for i in range(len(copied_value)):
            copied_value[i] = list(copied_value[i])

        row_nr = action[0]
        col_nr = action[1]
        value_to_play = action[2]

        # Verifies if the position is available
        if copied_value[row_nr][col_nr] != 2:
            return False

        # Verifies if the value is valid
        if value_to_play != 0 and value_to_play != 1:
            return False

        # Verifies if the value is valid in the col
        adjacent_vertical_numbers = state.board.adjacent_vertical_numbers(
            row_nr, col_nr
        )
        if (
            value_to_play
            == adjacent_vertical_numbers[0]
            == adjacent_vertical_numbers[1]
        ):
            return False

        # Verifies if the value is valid in the row
        adjacent_horizontal_numbers = state.board.adjacent_horizontal_numbers(
            row_nr, col_nr
        )
        if (
            value_to_play
            == adjacent_horizontal_numbers[0]
            == adjacent_horizontal_numbers[1]
        ):
            return False

        # Verifies other possibilities
        if (
            value_to_play
            == adjacent_vertical_numbers[0]
            == state.board.get_number(row_nr + 2, col_nr)
        ):
            return False

        if (
            value_to_play
            == adjacent_vertical_numbers[1]
            == state.board.get_number(row_nr - 2, col_nr)
        ):
            return False

        if (
            value_to_play
            == adjacent_horizontal_numbers[0]
            == state.board.get_number(row_nr, col_nr - 2)
        ):
            return False

        if (
            value_to_play
            == adjacent_horizontal_numbers[1]
            == state.board.get_number(row_nr, col_nr + 2)
        ):
            return False

        # Simulates play
        copied_value[row_nr][col_nr] = value_to_play

        zeros = 0
        ones = 0
        empties = 0

        # Verifies if the row is now full. If it is, verifies if there are any rows equal to this row
        if 2 not in copied_value[row_nr]:
            for i in range(size):
                if copied_value[i] == copied_value[row_nr] and i != row_nr:
                    return False

        for i in range(size):
            if copied_value[row_nr][i] == 0:
                zeros += 1
            elif copied_value[row_nr][i] == 1:
                ones += 1
            elif copied_value[row_nr][i] == 2:
                empties += 1
        if value_to_play == 1 and ones - zeros - empties > 1:
            return False
        if value_to_play == 0 and zeros - ones - empties > 1:
            return False

        zeros = 0
        ones = 0
        empties = 0

        # Verifies if the column is now full. If it is, verifies if there are any columns equal to this column

        value_np = np.array(copied_value)
        transposed_value = np.transpose(value_np)

        for i in range(size):
            if transposed_value[col_nr][i] == 0:
                zeros += 1
            elif transposed_value[col_nr][i] == 1:
                ones += 1
            else:
                empties += 1

        if value_to_play == 1 and ones - zeros - empties > 1:
            return False
        if value_to_play == 0 and zeros - ones - empties > 1:
            return False

        if 2 not in list(transposed_value[row_nr]):
            curr_row = list(transposed_value[row_nr])
            for i in range(size):
                if list(transposed_value[i]) == curr_row and i != row_nr:
                    return False
        return True

    def actions(self, state: TakuzuState):
        """Retorna uma lista de ações que podem ser executadas a
        partir do estado passado como argumento."""

        first_play = []
        possible_actions = []
        # Searches for a mandatory play
        for i in range(state.board.size):
            for j in range(state.board.size):
                if state.board.value[i][j] == 2:
                    if self.canPlay(state, (i, j, 0)):
                        possible_actions.append((i, j, 0))
                    if self.canPlay(state, (i, j, 1)):
                        possible_actions.append((i, j, 1))
                if len(possible_actions) == 1:
                    return possible_actions
                if first_play == []:
                    if len(possible_actions) == 2:
                        first_play = possible_actions.copy()

                possible_actions = []
        return first_play

    def result(self, state: TakuzuState, action):
        """Retorna o estado resultante de executar a 'action' sobre
        'state' passado como argumento. A ação a executar deve ser uma
        das presentes na lista obtida pela execução de
        self.actions(state)."""

        new_value = list(np.copy(state.board.value))
        for i in range(len(new_value)):
            new_value[i] = list(new_value[i])

        new_value[action[0]][action[1]] = action[2]
        newBoard = Board(new_value, self.size, state.board.available_positions - 1)

        return TakuzuState(newBoard)

    def goal_test(self, state: TakuzuState):
        """Retorna True se e só se o estado passado como argumento é
        um estado objetivo. Deve verificar se todas as posições do tabuleiro
        estão preenchidas com uma sequência de números adjacentes."""
        return state.board.available_positions == 0

    def h(self, node: Node):
        """Função heuristica utilizada para a procura A*."""
        # TODO
        pass


if __name__ == "__main__":
    board = Board.parse_instance_from_stdin()
    problem = Takuzu(board)
    goal_node = depth_first_tree_search(problem)
    print(goal_node.state.board, sep="", end="")
