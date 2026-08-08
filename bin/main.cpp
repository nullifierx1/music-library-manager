#include <boost/tokenizer.hpp>
#include <iostream>

int main(void) {
    std::string s("hello little kitty");
    boost::tokenizer<> tok(s);

    for (const auto& token : tok) {
        std::cout << token << " ";
    }

    std::cout << std::endl;
}