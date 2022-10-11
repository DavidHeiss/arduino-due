with open("output1") as fp1:
    with open("output2") as fp2:
        values1 = list(sorted(map(lambda x: x.strip(), fp1.readlines())))
        values2 = list(sorted(map(lambda x: x.strip(), fp2.readlines())))

        counter = 0
        for v1,v2 in zip(values1,values2):
        # for value1 in values1:
            # for value2 in values2:
            # print(f"{value1} {value2}")
            print(f"{v1} {v2}")
