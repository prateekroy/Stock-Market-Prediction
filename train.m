clc
clear all
close all

u=0.2;
mse=0;
load z.txt;
m=max(z);
n=min(z);
for k=1:length(z)
    b(k)=(z(k)-n)/(m-n);
end

for j=1:1000
    n(j,1:6)=b(j:j+5);
end


testdata=1000;
mse=0;
popsize = 4;
stringlength = 4;
variables=5;
pop=rand(2*popsize,stringlength,variables);

for i=1:2*popsize
    for j=1:stringlength
        for k=1:variables
        if pop(i,j,k)>0.5
            pop(i,j,k)=1;
        else
            pop(i,j,k)=0;
        end
        end
    end
end
    
totalfitness(1:testdata)=0;
predt(1:testdata)=0;
z=1;

while (z<=testdata)

val(1:2*popsize,1:variables)=0;
for i = 1:2*popsize
    
    for k = 1:(variables)
    for j = 1:(stringlength-1)
        
                val(i,k) = (val(i,k)+pop(i,j,k))*2;
        end
    
    
    val(i,k)=val(i,k)+pop(i,stringlength,k);
    end
    
    for m=1:variables
    w(i,m)=(val(i,m)*0.4)/2^stringlength;
    end
    fitness(i)=n(z,6)-tanh((n(z,1:5)*w(1:5)'));
end




   
for k=1:variables
count=1;
while count <= popsize
    i=fix(rand*(2*popsize-1))+1;
    j=fix(rand*(2*popsize-1))+1;
    if i~=j
        if fitness(i)<fitness(j)
            if rand<0.75
                parent(count,:,k)=pop(i,:,k);
            else
                parent(count,:,k)=pop(j,:,k);
            end
        else
            if rand<0.75
                parent(count,:,k)=pop(j,:,k);
            else
                parent(count,:,k)=pop(i,:,k);
            end
        end
        count=count+1;
    end
end
end

for k=1:variables
for i=1:2:(popsize-1)
    crosspoint=fix(rand*stringlength)+1;
    s1=parent(i,:,k);
    s2=parent(i+1,:,k);
    part=s1(crosspoint:stringlength);
    s1(crosspoint:stringlength)=s2(crosspoint:stringlength);
    s2(crosspoint:stringlength)=part;
    offspring(i,:,k)=s1;
    offspring(i+1,:,k)=s2;
end
pop(1:popsize,:,k)=parent(1:popsize,:,k);
pop(popsize+1:2*popsize,:,k)=offspring(1:popsize,:,k);
end

for k=1:variables
for i=1:2:(popsize-1)
    mut=fix(2*popsize*stringlength*0.01);
    for iter=1:mut
        c=fix(rand*(stringlength-1))+1;
        r=fix(rand*(2*popsize-1))+1;
        if pop(r,c,k)==1
            pop(r,c,k)=0;
        else
            pop(r,c,k)=1;
        end
    end
end
end



val(1:2*popsize,1:variables)=0;
for i = 1:2*popsize
    for k = 1:(variables)
        for j = 1:(stringlength-1)    
       val(i,k) = (val(i,k)+pop(i,j,k))*2;
        end      
    val(i,k)=val(i,k)+pop(i,stringlength,k);
    end
     for m=1:variables
            w(m)=(val(i,m)*0.4)/2^stringlength;
     end
    actualt(z)=n(z,6);
    predt(z)=predt(z)+tanh((n(z,1:5)*w(1:5)'));
    fitness(i)=n(z,6)-tanh((n(z,1:5)*w(1:5)'));
    totalfitness(z)=totalfitness(z)+fitness(i);
end

if(z>1)
if(abs(totalfitness(z))>totalfitness(z-1))
        totalfitness(z)=n(z,6)-tanh((n(z,1:5)*ww(1:5)'));

end
end
predt(z)=predt(z)/8;
tf(z)=(totalfitness(z)^2)/64;
mse=mse+tf(z);
mape(z)=(actualt(z)-predt(z))/actualt(z);
z=z+1;
ww=w;
end

tmse=mse/testdata;
tmse

figure
plot(1:testdata,tf);
figure
plot(1:testdata,actualt,1:testdata,predt);


s=1;
mset=0;
for z = 1000:1:2500
    nt(s,1:6)=b(z:z+5);
    s=s+1;
end

for z = 1:1500
    actual(z)=nt(z,6);
    pred(z)=(nt(z,1:5)*w(1:5)');
    tfitness(z)=actual(z)-(nt(z,1:5)*w(1:5)');
    ttf(z)=(tfitness(z)^2);
    mset=mset+ttf(z);
    mape(z)=(actual(z)-pred(z))/actual(z);
    z=z+1;
end
tmset=mset/1500;
tmset
t=1:1500;
figure
plot(t,actual,t,pred);
