head' :: [a]->a
head' [] = error "Can't call head on an empty list, dummy!"
head' (x:_) = x