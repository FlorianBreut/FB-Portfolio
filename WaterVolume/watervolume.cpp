
class Cell
{
public:

	Cell() { m_y = 0; m_x = 0; }
	Cell(unsigned short row, unsigned short col, unsigned short water_lvl) :m_y(row), m_x(col), m_water_lvl(water_lvl) {}

	unsigned short getRow() { return m_y; }
	unsigned short getCol() { return m_x; }
	unsigned short getWaterLvl() { return m_water_lvl; }

	~Cell() {}

private:
	int m_y;
	int m_x;
	unsigned short m_water_lvl;
};


// Binary heap implementation of minimum priority to sort cells depending on their water level
class MinLvlCellPrioQueue
{

public:

	MinLvlCellPrioQueue(unsigned int max_size)
		:m_max_size(max_size)
	{
		m_nb_elem = 0;
		m_data = new Cell*[m_max_size];
	};

	~MinLvlCellPrioQueue()
	{
		for (unsigned int i = 0; i < m_nb_elem; ++i)
		{
			if (m_data[i])
			{
				delete m_data[i];
				m_data[i] = 0;
			}
		}
	};

	const int getSize() { return m_nb_elem; }

	int parent(int i) { return (i - 1) / 2; }

	int leftChild(int i) { return 2 * i + 1; }

	int rightChild(int i) { return 2 * i + 2; }

	void swap(Cell **elem1, Cell **elem2)
	{
		Cell *elem_temp = *elem1;
		*elem1 = *elem2;
		*elem2 = elem_temp;
	}

	// Add cell element to the heap and 
	void push(Cell *elem)
	{
		m_data[m_nb_elem] = elem;
		++m_nb_elem;
		int i = m_nb_elem - 1;
		while (i != 0 && m_data[parent(i)]->getWaterLvl() > m_data[i]->getWaterLvl())
		{
			swap(&m_data[parent(i)], &m_data[i]);
			i = parent(i);
		}
	};

	void minHeapify(int i)
	{
		unsigned int left_child = leftChild(i);
		unsigned int right_child = rightChild(i);
		int lowest = i;
		if (left_child <= m_nb_elem && m_data[left_child]->getWaterLvl() < m_data[lowest]->getWaterLvl())
		{
			lowest = left_child;
		}
		if (right_child <= m_nb_elem && m_data[right_child]->getWaterLvl() < m_data[lowest]->getWaterLvl())
		{
			lowest = right_child;
		}
		if (lowest != i)
		{
			Cell *elem_temp = m_data[i];
			m_data[i] = m_data[lowest];
			m_data[lowest] = elem_temp;
			minHeapify(lowest);
		}
	}

	// return minimum water level cell and reorder the heap to conserve priority property
	Cell* pop()
	{
		Cell *min_elem = m_data[0];
		m_data[0] = m_data[m_nb_elem - 1];
		--m_nb_elem;
		minHeapify(0);
		return min_elem;
	};

private:

	unsigned int m_max_size;
	unsigned int m_nb_elem;
	Cell **m_data;

}
;


// Utils functions
template<class T1> const T1& max(const T1& a, const T1& b) { return (a < b) ? b : a; }
template<class T2> const T2& min(const T2& a, const T2& b) { return (a > b) ? b : a; }


// To access height value of (row,col) cell
unsigned short get1DArrayElem(const unsigned short *arr, const unsigned short row, const unsigned short col, const unsigned short a_w)
{
	return arr[a_w*row + col];
};


// Compute the Volume of the input board
unsigned __int64 CalculateVolume(const unsigned short *a_board, unsigned short a_w, unsigned short a_h)
{
	unsigned __int64 volume = 0;

	if (a_w < 3 || a_h < 3)
	{
		volume = 0;
		return volume;
	}

	unsigned int max_pq_size = a_w * a_h;

	// Instanciate a minimum water level priority queue
	MinLvlCellPrioQueue pq(max_pq_size);

	// Create and inititialize 2D Array to store water levels
	unsigned short** water_lvl;
	water_lvl = new unsigned short*[a_h];
	for (unsigned short j = 0; j < a_h; j++)
	{
		water_lvl[j] = new unsigned short[a_w];
	}

	// Initialize water levels to infinity (max unsigned short value)
	for (unsigned short j = 0; j < a_h; j++)
	{
		for (unsigned short i = 0; i < a_w; i++)
		{
			water_lvl[j][i] = 0xffff;
		}
	}

	// Initialize board edges water level to the the board height
	// And add them to the min water level priority queue
	for (unsigned short i = 0; i < a_w; i++)
	{
		water_lvl[0][i] = get1DArrayElem(a_board, 0, i, a_w);
		water_lvl[a_h - 1][i] = get1DArrayElem(a_board, a_h - 1, i, a_w);
		Cell *cell_top_i = new Cell(0, i, water_lvl[0][i]);
		Cell *cell_bot_i = new Cell(a_h - 1, i, water_lvl[a_h - 1][i]);
		pq.push(cell_top_i);
		pq.push(cell_bot_i);
	}
	for (unsigned short j = 1; j < a_h - 1; j++)
	{
		water_lvl[j][0] = get1DArrayElem(a_board, j, 0, a_w);
		water_lvl[j][a_w - 1] = get1DArrayElem(a_board, j, a_w - 1, a_w);
		Cell *cell_left_i = new Cell(j, 0, water_lvl[j][0]);
		Cell *cell_right_i = new Cell(j, a_w - 1, water_lvl[j][a_w - 1]);
		pq.push(cell_left_i);
		pq.push(cell_right_i);
	}

	short dx[4] = { 1, -1, 0, 0 };
	short dy[4] = { 0, 0, 1, -1 };
	while (pq.getSize() > 0)
	{
		// extract the min water level cell from the priority queue
		Cell* min_lvl_cell = pq.pop();
		unsigned short xm = min_lvl_cell->getCol();
		unsigned short ym = min_lvl_cell->getRow();

		// loop on all 4 adjacent cells 
		for (unsigned short k = 0; k < 4; k++)
		{
			unsigned short xk = xm + dx[k];
			unsigned short yk = ym + dy[k];
			if (xk >= 0 && xk < a_w && yk >= 0 && yk < a_h)
			{
				unsigned short temp = water_lvl[yk][xk];
				// Determine new water level for the cell
				water_lvl[yk][xk] = max(get1DArrayElem(a_board, yk, xk, a_w), min(water_lvl[ym][xm], temp));
				if (water_lvl[yk][xk] != temp)
				{
					// Add water level changing cell to the queue
					Cell *new_cell = new Cell(yk, xk, water_lvl[yk][xk]);
					pq.push(new_cell);
				}
			}
		}

		// free memory allocated to the cell removed from the priority queue
		delete min_lvl_cell;
		min_lvl_cell = 0;
	}

	// for each cell the water volume is the difference between the water level and the cell height
	for (unsigned short j = 0; j < a_h; j++)
	{
		for (unsigned short i = 0; i < a_w; i++)
		{
			volume += water_lvl[j][i] - get1DArrayElem(a_board, j, i, a_w);
		}
	}

	// free allocated memory to the water level 2d array
	for (unsigned short j = 0; j < a_h; j++)
	{
		delete[] water_lvl[j];
	}
	delete[] water_lvl;

	return volume;
}


int main()
{
	// test set A
	unsigned __int64 volume_board_test_a1(0), volume_board_test_a2(0);
	unsigned short board_w_a = 3;
	unsigned short board_h_a = 4;
	unsigned short board_test_a1[12] = { 4, 3, 3, 4, 2, 3, 4, 1, 4, 4, 4, 4 };
	unsigned short board_test_a2[12] = { 4, 3, 3, 4, 2, 3, 4, 1, 1, 4, 4, 4 };
	volume_board_test_a1 = CalculateVolume(board_test_a1, board_w_a, board_h_a);
	volume_board_test_a2 = CalculateVolume(board_test_a2, board_w_a, board_h_a);

	// test set B
	unsigned __int64 volume_board_test_b1(0);
	unsigned short board_w_b = 10;
	unsigned short board_h_b = 1;
	unsigned short board_test_b1[10] = { 1,0,0,1,0,0,0,0,0,1 };
	volume_board_test_b1 = CalculateVolume(board_test_b1, board_w_b, board_h_b);

	// test set C
	unsigned __int64 volume_board_test_c1(0), volume_board_test_c2(0);
	unsigned short board_w_c = 5;
	unsigned short board_h_c = 6;
	unsigned short board_test_c1[30] = { 1,3,0,2,1,2,2,5,2,2,4,3,1,5,3,4,3,1,5,5,0,1,2,0,2,2,2,1,4,5 };
	volume_board_test_c1 = CalculateVolume(board_test_c1, board_w_c, board_h_c);

	return 0;
}
