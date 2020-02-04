for i=1:10
    [Xte, Yte]=uo_nn_dataset(1700962+i, 5, [1,2,3,4,5], 0.5); %generate dataset
    [res]=identifythenumber(Xte); %find our prediction
    [Xres, Yres]=uo_nn_dataset_modified(5, res); %prepare our solution to be plotted

    uo_nn_Xyplot(Xte, Yte, []); 
    print(num2str(i),'-djpeg');
    
    uo_nn_Xyplot(Xres, Yres, []);
    print(num2str(10+i),'-djpeg');
end