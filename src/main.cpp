#include <iostream>

using namespace std;

namespace
{

int zero()
{
    int *zero = 0;
    *zero = 0;
    return *zero;
}

} // namespace

int main()
{
    cout << "Hello, World!" << endl;
    return zero();
}
