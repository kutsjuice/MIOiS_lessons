using PyPlot
using LinearAlgebra
nx = 10;
ny = 3;

nodes = Matrix{Float64}(undef, 2, nx * ny);
dx = 0.6
dy = 0.6

function fillnodes!(nodes, nx, ny, dx, dy)
	for i in 1:nx
		for j in 1:ny
			x = (i - 1) * dx
			y = (j - 1) * dy
			k = (i - 1) * ny + j
			println(i, " ", j)
			nodes[1, k] = x
			nodes[2, k] = y
		end
	end
end

fillnodes!(nodes, nx, ny, dx, dy)

elnum = (nx - 1) * (ny - 1) * 4 + (ny - 1) + (nx - 1) 
elements = Matrix{Integer}(undef, 2, elnum)
function fillelements!(elements, nx, ny)
	k = 0
    for j in 2:ny
        nodenum1 = j
        nodenum2 = j -1
        k+=1 
        elements[:,k] = [nodenum1,nodenum2]
    end
    
    for i in 2:nx
        nodenum1 = (i-1)*ny+1
        nodenum2 = (i-2)*ny+1
        k+=1 
        elements[:,k] = [nodenum1,nodenum2]
    end

	for i in 2:nx
		for j in 2:ny
			nodenum1 = (i - 1) * ny + j
			nodenum2 = nodenum1 - ny
			nodenum3 = nodenum2 - 1
			nodenum4 = nodenum1 - 1

			k += 1
			elements[:, k] = [nodenum1, nodenum2]
			k += 1
			elements[:, k] = [nodenum1, nodenum3]
			k += 1
			elements[:, k] = [nodenum1, nodenum4]
			k += 1
			elements[:, k] = [nodenum2, nodenum4]


		end
	end


end

fillelements!(elements, nx, ny)
function plot_mesh(elements, nodes, disps, scale)

	for elem in eachcol(elements)
		ix = elem[1]*2-1
		iy = elem[1]*2
		jx = elem[2]*2-1
		jy = elem[2]*2
		x1 = nodes[1,elem[1]] + disps[ix]*scale
		y1 = nodes[2,elem[1]] + disps[iy]*scale
		
		x2 = nodes[1,elem[2]] + disps[jx]*scale
		y2 = nodes[2,elem[2]] + disps[jy]*scale
		plot([x1,x2], [y1, y2])
	end
	gca().set_aspect(1)
end

plot_mesh(elements, nodes, similar(nodes), 0)


stiffness_matrix = zeros( size(nodes,2)*2, size(nodes,2)*2);

function calc_local_stiffness_matrix(nodes, k)
	dx = nodes[1,2] - nodes[1,1];
	dy = nodes[2,2] - nodes[2,1];
	l = sqrt(dx*dx + dy*dy)
	ret = Matrix{Float64}([
		dx*dx   dx*dy  -dx*dx  -dx*dy;
		dx*dy   dy*dy  -dx*dy  -dy*dy;
		-dx*dx -dx*dy   dx*dx   dx*dy;
		-dx*dy -dy*dy   dx*dy   dy*dy;
	]);
	ret *= k/l^2;
	return ret;
end

el = elements[:,1]
nodes[:,el]


S = 0.01*0.08
E = 2.1e11
k = E * S

for el in eachcol(elements)
	element_nodes = nodes[:, el]
	stiffness_matrix_local = calc_local_stiffness_matrix(element_nodes, k)
	ix = el[1]*2 - 1;
	iy = el[1]*2
	jx = el[2]*2 - 1;
	jy = el[2]*2;
	stiffness_matrix[[ix,iy,jx,jy], [ix,iy,jx,jy]] .= stiffness_matrix_local; 
end




# imshow(stiffness_matrix)

# rank(stiffness_matrix)
# size(stiffness_matrix)

fixed_nodes = [1, size(nodes,2) - 2]
maxk = abs(maximum(stiffness_matrix))



function fix_nodes(stiff_mat, nodes)
	for node in nodes
		stiff_mat[node[i]*2 - 1, node[i]*2 - 1] += maxk *1e4;
		stiff_mat[node[i]*2, node[i]*2] += maxk *1e4;
	end
end

f = ones(size(nodes,2) * 2) * 100


disps = stiffness_matrix \ f

plot_mesh(elements, nodes, disps, 1e5)

