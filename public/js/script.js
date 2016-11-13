function addMemberRow() {
	var memberSection = document.getElementById('member-section');

	var p = document.createElement('p');
	p.setAttribute('id', 'add-members');
	
	div = document.createElement('div');
	div.setAttribute('class', 'form-group form-inline');

	inp1 = document.createElement('input');
	inp1.setAttribute('type', 'text');
	inp1.setAttribute('name', 'member[]');
	inp1.setAttribute('placeholder', 'New Member');
	inp1.setAttribute('class', 'form-control');

	inp2 = document.createElement('input');
	inp2.setAttribute('type', 'email');
	inp2.setAttribute('name', 'member_email[]');
	inp2.setAttribute('placeholder', 'Email');
	inp2.setAttribute('class', 'form-control');

	div.appendChild(inp1);
	div.appendChild(inp2);
	p.appendChild(div);
	memberSection.appendChild(p);
}

function splitCalculation(numUsers) {
	var splitCal = document.getElementById('split-calculation');
	var splitMethod = document.getElementById('split_method');
	var totalAmount = document.getElementById('total_amount');

	if (totalAmount.value != 0) {
		switch(splitMethod.options[splitMethod.selectedIndex].value) {
				case "Split Equally": 
					individual = parseFloat(totalAmount.value) / numUsers;
					individual = individual.toFixed(2);
					splitCal.innerHTML = individual;

					splitSection1 = document.getElementById('split-section-1');
					splitSection1.style.display = "block";

					splitSection2 = document.getElementById('split-section-2');
					splitSection2.style.display = "none";

					splitSection3 = document.getElementById('split-section-3');
					splitSection3.style.display = "none";

					break;
				case "Split By Shares":
					splitSection1 = document.getElementById('split-section-1');
					splitSection1.style.display = "none";

					splitSection2 = document.getElementById('split-section-2');
					splitSection2.style.display = "block";

					splitSection3 = document.getElementById('split-section-3');
					splitSection3.style.display = "none";

					individual = parseFloat(totalAmount.value) / numUsers;
					individual = individual.toFixed(2);

					for (var i = 0; i < numUsers; i++) {
						document.getElementById('individual-amt-'+(i+1)).innerHTML = individual;
					}

					break;
				case "Split By %":
					splitSection1 = document.getElementById('split-section-1');
					splitSection1.style.display = "none";

					splitSection2 = document.getElementById('split-section-2');
					splitSection2.style.display = "none";

					splitSection3 = document.getElementById('split-section-3');
					splitSection3.style.display = "block";

					break;
		}
	}
}

function splitByShareCalc(numUsers) {
	var totalAmount = document.getElementById('total_amount');

	shares = [];
	numShares = 0;
	for (var i = 0; i < numUsers; i++) {
		shares[i] = parseInt(document.getElementById('split-share-'+(i+1)).value);
		numShares += shares[i];
	}

	individual = parseFloat(totalAmount.value) / numShares;
	individual = individual.toFixed(2);

	for (var i = 0; i < numUsers; i++) {
		document.getElementById('individual-amt-'+(i+1)).innerHTML = shares[i] * individual;
	}
}

function splitByPerCalc(numUsers) {
	var totalAmount = document.getElementById('total_amount');

	per = [];
	sum = 0;
	console.log("numUsers : " + numUsers);
	for (var i = 0; i < numUsers; i++) {
		per[i] = parseInt(document.getElementById('split-per-'+(i+1)).value);
		sum += per[i];
		console.log("share : " + per[i]);
	}

	var totalPer = document.getElementById('total-per');
	var leftPer = document.getElementById('left-per');

	totalPer.innerHTML = sum;
	leftPer.innerHTML = 100 - sum;

	totalAmount = parseFloat(totalAmount.value);

	for (var i = 0; i < numUsers; i++) {
		individual = (per[i] * totalAmount) / 100;
		individual = individual.toFixed(2);
		console.log("totalAmount : " + totalAmount);
		console.log("individual : " + individual);

		document.getElementById('individual-amt-per-'+(i+1)).innerHTML = individual;
	}
}