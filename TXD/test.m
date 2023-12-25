clc;
clear all;
close all;
%% -----System Parameters  (put the parameters of the system here)-----
bandwidth = 25.08e6;                                                       %%% bandwidth of DS_FH signal
CNR = 62;                                                                  %%% carrier to noise ratio
SNR = CNR-10*log10(bandwidth);                                             %%% signal to noise ratio
Nch = 250;                                                                 %%% number of coherent integration point
Nnch = 80;                                                                 %%% times of nocoherent integration
Nc  = 2500;                                                                %%% chip period (# of chips to repeat itself)
Nh = 55;                                                                   %%% Frequnency of hopping code to repeat itself
NumFhFreq = 128;                                                           %%% FhFreq number
Fdmax = 100e3;                                                             %%% doppler range [-100kHz~100kHz]
Fd_velocity = 15e3;                                                        %%% velocity of Fd change
Fca = 2e9;                                                                 %%% Frequnency of signal carrier
Fc = 10e6;                                                                 %%% chip rate
Fcp = Fc/Nc;                                                               %%% chip period rate
Fb = 20000;                                                                %%% info Bit rate
Fh = 20000;                                                                %%% hopping rate (#of hops per second)
Fs  = 110e6;                                                               %%% signal sampling rate
Fo = 27.5e6;                                                               %%% Freqency of IF signal
FhFreq_inteval = 40e3;                                                     %%% FhFreq range [0~5.08MHZ]
Ts = 1/Fs;                                                                 %%% sample interval
Tc = 1/Fc;                                                                 %%% per chip duration 
Tb = 1/Fb;                                                                 %%% per info Bit duration 
Th = 1/Fh;                                                                 %%% per hopping frequency duration (hopping residence time)
Tcp = Nc*Tc;                                                               %%% per chip period duration 
Thp = Th*Nh;                                                               %%% per hopping period duration 
FsTc = Fs*Tc;                                                              %%% samples per chip
FsTb = Fs*Tb;                                                              %%% samples per bit
FsTh = Fs*Th;                                                              %%% samples per hopping residence time
FcTb = Fc*Tb;                                                              %%% chips per hop
FcTh = Fc*Th;                                                              %%% chips per info Bit
FbTcp = Fb*Tcp;                                                            %%% info Bits per DsCode period
FbThp = Fb*Th*Nh;                                                          %%% info Bits per hopping period
FcpThp = Fcp*Th*Nh;                                                        %%% chip period numnbers per hopping period
NhTb = Fh*Tb;                                                              %%% hopping numbers per info bit
NhTcp = Fh*Tcp;                                                            %%% hopping numbers per chip period
SysParameter.Nc = Nc;
SysParameter.Nh = Nh;
SysParameter.NumFhFreq = NumFhFreq;
SysParameter.Fdmax = Fdmax;
SysParameter.Fd_velocity = Fd_velocity;
SysParameter.Fca = Fca;
SysParameter.Fc = Fc;
SysParameter.Fcp = Fcp;
SysParameter.Fb = Fb;
SysParameter.Fh = Fh;
SysParameter.Fs = Fs;
SysParameter.Fo = Fo;
SysParameter.FhFreq_inteval = FhFreq_inteval;
SysParameter.Ts = Ts;
SysParameter.Tc = Tc;
SysParameter.Tb = Tb;
SysParameter.Th = Th;
SysParameter.Tcp = Tcp;
SysParameter.FsTc = FsTc;
SysParameter.FsTb = FsTb;
SysParameter.FsTh = FsTh;
SysParameter.FcTb = FcTb;
SysParameter.FcTh = FcTh;
SysParameter.FbTcp = FbTcp;
SysParameter.FbThp = FbThp;
SysParameter.FcpThp = FcpThp;
SysParameter.NhTb = NhTb;
SysParameter.NhTcp = NhTcp;

%%% 0. Generate 0.11s of data each time (including 40 frequency hopping period), generating a total of 10s of data
Fd = rand(1)*Fdmax*2 - Fdmax;
SigLen = 0.11*Fs;

%%% 1. generate the code sequence
DsCode = sign(randi(2,1,Nc)-1.5);

%%% 2. generate the FH frequency 
FhFreq_index = randi([1,SysParameter.NumFhFreq],[1,Nh])-1;
while(all(FhFreq_index - circshift(FhFreq_index,1)) == 0)                  %%% determine whether each frequnecy index is different
    FhFreq_index = randi([1,SysParameter.NumFhFreq],[1,Nh])-1;
end

%%% 3. generate the DSFH Sig
t_index = 0:0.11:10.01;
fid = fopen('Sig_data.dat','w');
for i = 1:length(t_index)
    Sig = DSFH(SysParameter,Fd,SigLen,DsCode,FhFreq_index,t_index(i));
    fwrite(fid,DSFH(SysParameter,Fd,SigLen,DsCode,FhFreq_index,t_index(i)),'double');
    i
end
fclose(fid);


