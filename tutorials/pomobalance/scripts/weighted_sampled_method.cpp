#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <random>
#include <string>
#include <algorithm>

#include <Rcpp.h>
using namespace Rcpp;


// samples a state from a pomo edge 0:(N-1) givent the weights of a 
// binomal distribution B(m|n/N,M)
// based on equation (13) of Schrempf et al. (2016) JTB
int sample_weight(int M, int m, int N){
  
  std::vector<double> weights(N+1);
  double prob;
  
  // calculating the weight vector
  for (int i=0; i < N+1; ++i){
    prob = 1.0*i/N;
    weights[i] = pow(prob,m)*pow(1-prob,M-m);
  }
  
  // sampling a pomo state from the weight vector 
  std::random_device rd;
  std::mt19937 gen(rd());
  std::discrete_distribution<> d(weights.begin(), weights.end());
  
  return d(gen);
  
}

// samples a pomo edge from a matrix of allele_indexes*edge_indexes matrix
// the matrix estipulates wich edges contain the allele allele_index
int sample_edge(int allele_index, std::vector<int> vector){
  
  // setting the appropriate sub vector to sample from
  // the edge matrix is indexed as [allele_index,edge_index]
  // the sub vector pics the allele_index line
  std::vector<int> sub_vector = {vector.begin() + allele_index*6, vector.begin() + allele_index*6 + 6};

  // sampling a pomo edge
  std::random_device rd;
  std::mt19937 gen(rd());
  std::discrete_distribution<> d( sub_vector.begin(), sub_vector.end() );

  return d(gen);
  
}


// gets the edge of an observed polymorphic count
int get_index(std::vector<std::string> vector, std::string element) {
  
  for (int i=0; i<vector.size(); ++i){
    if (vector[i]==element){
      return i;
    }
  }
  return -1;
}


// converts the count to pomo states
// this is a combination of the sampled and weighted methods explained in
// Schrempft et al. (2016)
// the weighted-sampled method still calculates the weight vector, but it is used
// to sample a pomo state and not to weight the tree tips

// [[Rcpp::export]]
std::string counts_to_pomo_states_converter(std::string count_file,int n_alleles, int N) {
  
  //number of edges
  int n_edges = (n_alleles*n_alleles - n_alleles)/2;
  

  // vector and matrix of edges 
  // vector of edges indexed as [edge_index] = "a_ia_j"
  // matrix of edges indexed as [allele_index,edge_index]
  // it indicates which edges have a certain allele: matrix of 0s and 1s
  std::vector<int> matrix_edges(n_alleles*n_edges,0);
  std::vector<std::string> vector_edges(n_edges);
  

  // generating all the possible pairwise combinations of alleles
  int edge = 0;
  for (int i=0; i<n_alleles; ++i ){
    for (int j=(i+1); j<n_alleles; ++j){
      
      vector_edges[edge] = std::to_string(i)+std::to_string(j);
      matrix_edges[i*n_edges+edge] = 1;
      matrix_edges[j*n_edges+edge] = 1;
      edge += 1;
      
    }
  }
  

  //opening count file and checking existence 
  std::ifstream inFile;
  inFile.open(count_file);
  if (! inFile) {
    std::cout << "\n  Make sure " << count_file << " is in the working directory.\n\n";
    return "\n";
  }
  

  // reading the count file
  // cheking the count file will well formatted and getting number of taxa and sites

  std::string content, counts; 
  int n_taxa, n_sites, state;

  inFile >> content; 
  if (content != "COUNTSFILE"){
  	std::cout << "\n  " << count_file << " does not seem to be properly formatted. First line: COUNTSFILE NPOP # NSITES #";
  }

  inFile >> content;
  if (content != "NPOP"){
  	std::cout << "\n  " << count_file << " does not seem to be properly formatted. First line: COUNTSFILE NPOP # NSITES #";
  }

  inFile >> n_taxa;

  inFile >> content;
  if (content != "NSITES"){
  	std::cout << "\n  " << count_file << " does not seem to be properly formatted. First line: COUNTSFILE NPOP # NSITES #";
  }

  inFile >> n_sites;
  
  std::vector<std::string> taxa(n_taxa);
  
  inFile >> content;
  if (content != "CHROM"){
  	std::cout << "\n  " << count_file << " does not seem to be properly formatted. Second line: CHROM POS TaxaName1 TaxaName2 ...";
  }

  inFile >> content;
  if (content != "POS"){
  	std::cout << "\n  " << count_file << " does not seem to be properly formatted. Second line: CHROM POS TaxaName1 TaxaName2 ...";
  }

  // getting the taxa names
  for (int i=0; i<n_taxa; ++i){
    inFile >> taxa[i];
  }
  
  
  // going through the number of sites
  for (int i=0; i<n_sites; ++i){
    

    // reading CHROM and POS but no use to them
    inFile >> content;
    inFile >> content;

    // some important initializations    
    int value,state,int_index,M,m,weight,n_counts;

    // going through the number of taxa
    for (int j=0; j<n_taxa; ++j){
      
      // reading count pattern
      inFile >> counts;
      std::stringstream ss( counts );
      std::string count,str_index;

      // setting total counts, the last postive count (why last? important for state indexing), and number of non-null counts to 0
      M        = 0;
      n_counts = 0;
      
      // goes through the number of alleles
      // counts are comma separated
      for (int k=0; k<n_alleles; k++){
        
        getline( ss, count, ',' );
        value = stoi(count);
        
        // getting info from the count pattenr
        if (value > 0) {
          M        += value;
          m         = value;
          n_counts += 1;
          int_index = k;
          str_index = str_index + std::to_string(k);
        }
        
      }
      
      // pointing out some typical invalid counts: null counts (e.g., 0,0,0,0) and >2-allelic counts (e.g., 0,1,1,1)
      if (n_counts==0){
        std::cout << "\n  Unexpected count pattern: " << counts << ". PoMos require at least one postive count.\n\n";
        return "\n";
      }
      if (n_counts>2){
        std::cout << "\n  Unexpected count pattern: " << counts << ". PoMos only accept monoallelic or biallelic counts.\n\n";
        return "\n";
      }
      
      // sampling a 0:N frequency from the weight vector 
      weight = sample_weight(M, m, N);
      
      // determining the pomo state
      // three possible situations
      // if the count is monoallelic & likely "sampled" from a fixed state
      if (weight==N){
        
        state = int_index;
        //std::cout << "  " << state << "\n";

      // if the count is monoallelic & likely "sampled" from a polymoprhic state
      } else if (n_counts==1 & weight<N ) {
        
        edge = sample_edge(int_index, matrix_edges);
        state = n_alleles+edge*N-edge+weight-1;
        //std::cout << "  " << state << "\n";
      
      // if the count is biallelic, thus necessarily sampled from a polymoprhic state
      } else if (n_counts>1) {
        
        edge = get_index(vector_edges,str_index);
        state = n_alleles+edge*N-edge+weight-1;
        //std::cout << "  " << state << "\n";
        
      }
      
      std::cout << "Pattern: " << counts << " State: " << state << "\n";

      // creating the NaturalNumber type file for RevBayes
      taxa[j] += " " + std::to_string(state);
      
    }
    
  }
  
  // summarizing 
  std::cout << "\n\n  Number of alleles               " << n_alleles << 
                 "\n  Number of sites                 " << n_sites <<
                 "\n  Number of virtual individuals   " << N <<
                 "\n  Number of PoMo states           " << n_alleles*(1.0+(n_alleles-1.0)*(N-1.0)*0.5) <<
                 "\n  Number of taxa                  " << n_taxa << "\n\n";

  
  // creating the alignment and returning it
  std::string alignment = "";
  for (int i=0; i<n_taxa; ++i){
    alignment += taxa[i] + "\n";
  }
  return alignment;  

}